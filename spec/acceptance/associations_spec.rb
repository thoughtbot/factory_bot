describe "associations" do
  context "when accidentally using an implicit delcaration for the factory" do
    it "raises an error about the trait not being registered" do
      define_class("Post")

      FactoryBot.define do
        factory :post do
          author factory: user
        end
      end

      expect { FactoryBot.build(:post) }.to raise_error(
        ArgumentError,
        "Association 'author' received an invalid factory argument.\n" \
        "Did you mean? 'factory: :user'\n",
      )
    end
  end

  context "when building an association through the evaluator" do
    before do
      define_model("User", name: :string)

      define_model("Thumbnail", user_id: :integer) do
        belongs_to :user
      end

      FactoryBot.define do
        factory :user do
          name { "John Doe" }
        end

        factory :thumbnail do
          user
        end
      end
    end

    context "when the association and factory name match" do
      before do
        define_model("Post", user_id: :integer, thumbnail_id: :integer) do
          belongs_to :user
          belongs_to :thumbnail
        end

        FactoryBot.define do
          factory :post do
            association(:user, name: "Joe Poster")
            thumbnail { association(:thumbnail, user: user) }
          end
        end
      end

      it "uses the referenced association's object" do
        post = FactoryBot.create(:post)
        expect(post.thumbnail.user).to eq(post.user)
      end
    end

    context "when the association and factory do not match" do
      before do
        define_model("Comment", user_id: :integer, avatar_id: :integer) do
          belongs_to :user
          belongs_to :avatar, class_name: "Thumbnail"
        end
      end

      context "when using the factory name directly" do
        before do
          FactoryBot.define do
            factory :comment do
              association(:user, name: "Joe Commmenter")
              avatar { association(:thumbnail, user: user) }
            end
          end
        end

        it "uses the referenced association's object" do
          comment = FactoryBot.create(:comment)
          expect(comment.avatar.user).to eq(comment.user)
        end
      end

      context "when supplying the factory option" do
        before do
          FactoryBot.define do
            factory :comment do
              association(:user, name: "Joe Commmenter")
              avatar { association(:avatar, factory: :thumbnail, user: user) }
            end
          end
        end

        it "uses the referenced association's object" do
          comment = FactoryBot.create(:comment)
          expect(comment.avatar.user).to eq(comment.user)
        end
      end
    end
  end
end
