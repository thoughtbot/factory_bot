describe "file attributes" do
  context "when an attribute uses a file" do
    it "assigns an file to the attribute" do
      define_class("Post") do |_class|
        attr_accessor :attachment
      end
      filename = File.expand_path("spec/support/text_file.txt")
      file_contents = File.read(filename)

      FactoryBot.define do
        factory :post do
          attachment { file_fixture(filename) }
        end
      end
      post = FactoryBot.build(:post)
      expect(post.attachment.original_filename).to eq ::File.basename filename
      expect(File.read(post.attachment)).to eq file_contents
    end
  end
end
