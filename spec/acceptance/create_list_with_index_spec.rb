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

    context "without a block" do
      subject { FactoryBot.create_list_with_index(:post, 20, title: "The Hunting of the Snark") }

      it "creates identical items" do
        subject.each do |record|
          expect(record.title).to eq "The Hunting of the Snark"
        end
      end
    end

    context "with a block that doesn't receive an index" do
      subject do
        FactoryBot.create_list_with_index(:post, 20, title: "The Listing of the Block") do |post|
          post.position = post.id
        end
      end

      it "uses the new values" do
        subject.each do |record|
          expect(record.position).to eq record.id
        end
      end
    end

    context "with a block that receives both the object and an index" do
      subject do
        FactoryBot.create_list_with_index(:post, 20, title: "The Listing of the Indexed Block") do |post, index|
          post.position = index
        end
      end

      it "uses the new values" do
        subject.each_with_index do |record, index|
          expect(record.position).to eq index
        end
      end
    end

    context "without the count" do
      subject { FactoryBot.create_list_with_index(:post, title: "The Hunting of the Bear") }
  
      it "raise ArgumentError with the proper error message" do
        expect { subject }.to raise_error(ArgumentError, /count missing/)
      end
    end
end
