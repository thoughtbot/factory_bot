describe "attribute aliases" do
  before do
    define_model("User", name: :string, age: :integer)
    define_model("Post", user_id: :integer, title: :string) do
      belongs_to :user
    end
  end

  context "defers to the last declared attribute amongst alias matches" do
    it "defers to the :user_id attribute when declared after the :user attribute" do
      FactoryBot.define do
        factory :user
        factory :post do
          user
          user_id { 99 }
        end
      end

      post = FactoryBot.build(:post)
      expect(post.user_id).to eq 99
      expect(post.user).to eq nil
    end

    it "defers to the :user attribute when declared after the :user_id attribute" do
      FactoryBot.define do
        factory :user
        factory :post do
          user_id { 99 }
          user
        end
      end

      post = FactoryBot.build(:post)
      expect(post.user_id).to eq nil
      expect(post.user).to be_an_instance_of(User)
    end
  end

  context "overriding an association by foreign key" do
    before do
      FactoryBot.define do
        factory :user
        factory :post do
          user
        end
      end
    end

    it "doesn't assign both an association and its foreign key" do
      post = FactoryBot.build(:post, user_id: 1)
      expect(post.user_id).to eq 1
      expect(post.user).to eq nil
    end

    it "allows a create strategy method to accept a foreign key override" do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user_id: user.id)
      expect(post.user).to eq user
      expect(post.user_id).to eq user.id
      expect(User.count).to eq 1
    end
  end

  context "assigning an association by passing factory" do
    it "assigns attributes correctly" do
      FactoryBot.define do
        factory :user do
          factory :user_with_name do
            name { "John Doe" }
          end
        end

        factory :post do
          user
        end

        factory :post_with_named_user, class: Post do
          user factory: :user_with_name, age: 20
        end
      end

      user = FactoryBot.create(:post_with_named_user).user
      expect(user.name).to eq "John Doe"
      expect(user.age).to eq 20
    end
  end

  context "when association overrides trait foreign key" do
    before do
      FactoryBot.define do
        factory :user do
          name { "Test User" }
        end

        factory :post do
          association :user
          title { "Test Post" }

          trait :with_system_user_id do
            user_id { 999 }
          end

          trait :with_user_id_100 do
            user_id { 100 }
          end

          trait :with_user_id_200 do
            user_id { 200 }
          end
        end
      end
    end

    it "prefers association override over trait foreign key" do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, :with_system_user_id, user: user)

      expect(post.user_id).to eq(user.id)
      expect(post.user).to eq(user)
      expect(User.count).to eq 1
    end

    it "uses trait foreign key when no association override is provided" do
      post = FactoryBot.create(:post, :with_system_user_id)

      expect(post.user_id).to eq(999)
      expect(User.count).to eq 1
    end

    it "handles multiple traits with foreign keys correctly" do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, :with_user_id_100, :with_user_id_200, user: user)

      expect(post.user_id).to eq(user.id)
      expect(post.user).to eq(user)
      expect(User.count).to eq 1
    end
  end

  context "when overrides include a :user_id foreign key" do
    it "handles setting the user association" do
      FactoryBot.define do
        factory :user do
          name { "test tester" }
        end

        factory :post do
          user
          user_id { 999 }
        end
      end

      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user_id: user.id)

      expect(post.user).to eq user
      expect(post.user_id).to eq user.id
      expect(User.count).to be 1
    end
  end

  context "when override provides an instance" do
    it "handle setting the user association" do
      FactoryBot.define do
        factory :user do
          name { "test tester" }
        end

        factory :post do
          user
          user_id { 999 }
        end
      end

      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: user)

      expect(post.user).to eq user
      expect(post.user_id).to eq user.id
      expect(User.count).to be 1
    end

    it "handle setting the user association" do
      FactoryBot.define do
        factory :user do
          name { "test tester" }
        end

        factory :post do
          user
          user_id { 999 }
        end
      end

      user = FactoryBot.create(:user)
      post = FactoryBot.build(:post, user: user)

      expect(post.user).to eq user
      expect(post.user_id).to eq user.id
      expect(User.count).to be 1
    end
  end
end
