require "open3"
require "rbconfig"

describe FactoryBot::Strategy::Stub, "when only factory_bot is required" do
  it "builds a stubbed object with an id and timestamps" do
    # A new process, because this suite has already loaded Active Record.
    script = <<~RUBY
      require "factory_bot"

      class Post
        attr_accessor :id, :created_at, :updated_at
      end

      FactoryBot.define { factory :post }

      post = FactoryBot.build_stubbed(:post)
      print [post.id.class, post.created_at.class, post.updated_at.class].join(",")
    RUBY

    lib = File.expand_path("../../../lib", __dir__)
    output, status = Open3.capture2e(RbConfig.ruby, "-I", lib, "-e", script)

    expect(output).to eq "Integer,Time,Time"
    expect(status).to be_success
  end
end
