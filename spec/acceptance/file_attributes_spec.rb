describe "file attributes" do
  class Attachment
    attr_accessor :file

    def initialize(file)
      @file = file
    end

    def attach(*args); end
  end

  context "when an attribute uses a file" do
    it "assigns an file to the attribute" do
      define_model("Post") do
        def self.has_one_attached(*args); end
        has_one_attached :attachment
        attr_accessor :attachment
        def attachment=(value)
          @attachment = Attachment.new(value)
        end
      end

      filename = File.expand_path("spec/support/text_file.txt")
      file_contents = File.read(filename)

      FactoryBot.define do
        factory :post do
          attachment { file_fixture(filename) }
        end
      end
      post = FactoryBot.build(:post)
      puts post.attachment.file.io
      expect(post.attachment).to receive(:attach).with(
        io: file_contents,
        filename: filename,
      )
    end
  end
end
