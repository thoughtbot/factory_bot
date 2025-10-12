describe "attribute aliases" do
  before do
    define_model("User", name: :string, age: :integer)
    define_model("Post", user_id: :integer, title: :string) do
      belongs_to :user
    end
  end

  context "when overrides include a :user_id foreign key" do
    it "handles setting the user association" do
      FactoryBot.define do
        factory :user
        factory :post do
          user
          user_id { 999 }
        end
      end

      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user_id: user.id)

      expect(post.user).to eq user
      expect(post.user_id).to eq user.id
      expect(User.count).to eq 1
    end
  end
end
