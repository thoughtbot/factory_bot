describe "create multiple instances" do
  before do
    define_model("Post", title: :string, position: :integer)

    FactoryBot.define do
      factory(:post) do |post|
        post.title { "Through the Looking Glass" }
        post.position { rand(10**4) }
      end
    end
  end

  context "without default attributes" do
    subject { FactoryBot.create_pair(:post) }

    its(:length) { should eq 2 }

    it "creates all the posts" do
      subject.each do |record|
        expect(record).not_to be_new_record
      end
    end

    it "uses the default factory values" do
      subject.each do |record|
        expect(record.title).to eq "Through the Looking Glass"
      end
    end
  end
end
