describe "attribute aliases" do
  around do |example|
    original_aliases = FactoryBot.aliases.dup
    example.run
  ensure
    FactoryBot.aliases.clear
    FactoryBot.aliases.concat(original_aliases)
  end

  describe "basic alias functionality" do
    it "allows using different parameter names that map to model attributes" do
      FactoryBot.aliases << [/author_name/, "name"]
      define_model("User", name: :string, author_name: :string)

      FactoryBot.define do
        factory :user do
          name { "Default Name" }
        end
      end

      user = FactoryBot.create(:user, author_name: "Custom Name")

      expect(user.author_name).to eq "Custom Name"
      expect(user.name).to be_nil
    end

    it "ignores factory defaults when alias is used" do
      FactoryBot.aliases << [/display_name/, "name"]
      define_model("User", name: :string, display_name: :string)

      FactoryBot.define do
        factory :user do
          name { "Factory Name" }
        end
      end

      user = FactoryBot.create(:user, display_name: "Override Name")

      expect(user.display_name).to eq "Override Name"
      expect(user.name).to be_nil
    end
  end

  describe "built-in _id aliases" do
    it "automatically alias between associations and foreign keys" do
      define_model("User", name: :string)
      define_model("Post", user_id: :integer) do
        belongs_to :user, optional: true
      end

      FactoryBot.define do
        factory :user do
          name { "Test User" }
        end

        factory :post
      end

      user = FactoryBot.create(:user)

      post_with_direct_id = FactoryBot.create(:post, user_id: user.id)
      expect(post_with_direct_id.user_id).to eq user.id

      post_with_association = FactoryBot.create(:post, user: user)
      expect(post_with_association.user_id).to eq user.id
    end

    it "prevents conflicts between associations and foreign keys" do
      define_model("User", name: :string, age: :integer)
      define_model("Post", user_id: :integer) do
        belongs_to :user
      end

      FactoryBot.define do
        factory :user do
          factory :user_with_name do
            name { "John Doe" }
          end
        end

        factory :post do
          user
        end
      end

      post_with_foreign_key = FactoryBot.build(:post, user_id: 1)

      expect(post_with_foreign_key.user_id).to eq 1
    end

    it "allows passing attributes to associated factories" do
      define_model("User", name: :string, age: :integer)
      define_model("Post", user_id: :integer) do
        belongs_to :user
      end

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

      created_user = FactoryBot.create(:post_with_named_user).user

      expect(created_user.name).to eq "John Doe"
      expect(created_user.age).to eq 20
    end
  end

  describe "custom alias patterns" do
    it "supports regex patterns with capture groups" do
      FactoryBot.aliases << [/(.+)_alias/, '\1']
      define_model("User", name: :string, name_alias: :string, email: :string, email_alias: :string)

      FactoryBot.define do
        factory :user do
          name { "Default Name" }
          email { "default@example.com" }
        end
      end

      user = FactoryBot.create(:user, name_alias: "Aliased Name", email_alias: "aliased@example.com")

      expect(user.name).to be_nil
      expect(user.email).to be_nil
      expect(user.name_alias).to eq "Aliased Name"
      expect(user.email_alias).to eq "aliased@example.com"
    end

    it "supports multiple alias patterns working together" do
      FactoryBot.aliases << [/primary_(.+)/, '\1']
      FactoryBot.aliases << [/alt_name/, "name"]
      define_model("User", name: :string, email: :string, primary_email: :string, alt_name: :string)

      FactoryBot.define do
        factory :user do
          name { "Default Name" }
          email { "default@example.com" }
        end
      end

      user = FactoryBot.create(:user, primary_email: "primary@example.com", alt_name: "Alternative Name")

      expect(user.name).to be_nil
      expect(user.email).to be_nil
      expect(user.primary_email).to eq "primary@example.com"
      expect(user.alt_name).to eq "Alternative Name"
    end

    it "works with custom foreign key names" do
      FactoryBot.aliases << [/owner_id/, "user_id"]
      define_model("User", name: :string)
      define_model("Document", user_id: :integer, owner_id: :integer, title: :string) do
        belongs_to :user, optional: true
      end

      FactoryBot.define do
        factory :user do
          name { "Test User" }
        end

        factory :document do
          title { "Test Document" }
        end
      end

      document_owner = FactoryBot.create(:user)
      document = FactoryBot.create(:document, owner_id: document_owner.id)

      expect(document.user_id).to be_nil
      expect(document.owner_id).to eq document_owner.id
      expect(document.title).to eq "Test Document"
    end
  end

  describe "edge cases" do
    it "allows setting nil values through aliases" do
      FactoryBot.aliases << [/clear_name/, "name"]
      define_model("User", name: :string, clear_name: :string)

      FactoryBot.define do
        factory :user do
          name { "Default Name" }
        end
      end

      user = FactoryBot.create(:user, clear_name: nil)

      expect(user.name).to be_nil
      expect(user.clear_name).to be_nil
    end

    context "when both alias and target attributes exist on model" do
      it "ignores factory defaults for target when alias is used" do
        FactoryBot.aliases << [/one/, "two"]
        define_model("User", two: :string, one: :string)

        FactoryBot.define do
          factory :user do
            two { "set value" }
          end
        end

        user = FactoryBot.create(:user, one: "override")

        expect(user.one).to eq "override"
        expect(user.two).to be_nil
      end
    end
  end

  describe "with attributes_for strategy" do
    it "includes alias names in hash and ignores aliased factory defaults" do
      FactoryBot.aliases << [/author_name/, "name"]
      define_model("User", name: :string, author_name: :string)

      FactoryBot.define do
        factory :user do
          name { "Default Name" }
        end
      end

      attributes = FactoryBot.attributes_for(:user, author_name: "Custom Name")

      expect(attributes[:author_name]).to eq "Custom Name"
      expect(attributes[:name]).to be_nil
    end
  end

  describe "attribute conflicts with _id patterns" do
    it "doesn't set factory defaults when alias is used instead of target attribute" do
      define_model("User", name: :string, response_id: :integer)

      FactoryBot.define do
        factory :user do
          name { "orig name" }
          response_id { 42 }
        end
      end

      attributes = FactoryBot.attributes_for(:user, name: "new name", response: 13.75)

      expect(attributes[:name]).to eq "new name"
      expect(attributes[:response]).to eq 13.75
      expect(attributes[:response_id]).to be_nil
    end

    it "allows setting both attribute and attribute_id without conflicts" do
      define_model("User", name: :string, response: :string, response_id: :float)

      FactoryBot.define do
        factory :user do
          name { "orig name" }
          response { "orig response" }
          response_id { 42 }
        end
      end

      user = FactoryBot.build(:user, name: "new name", response: "new response", response_id: 13.75)

      expect(user.name).to eq "new name"
      expect(user.response).to eq "new response"
      expect(user.response_id).to eq 13.75
    end

    context "when association overrides trait foreign key" do
      before do
        define_model("User", name: :string)
        define_model("Post", user_id: :integer, title: :string) do
          belongs_to :user, optional: true
        end

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
        post = FactoryBot.build(:post, :with_system_user_id, user: user)

        expect(post.user_id).to eq(user.id)
        expect(post.user).to eq(user)
      end

      it "uses trait foreign key when no association override is provided" do
        post = FactoryBot.build(:post, :with_system_user_id)

        expect(post.user_id).to eq(999)
      end

      it "handles multiple traits with foreign keys correctly" do
        user = FactoryBot.create(:user)
        post = FactoryBot.build(:post, :with_user_id_100, :with_user_id_200, user: user)

        expect(post.user_id).to eq(user.id)
        expect(post.user).to eq(user)
      end
    end
  end
end
