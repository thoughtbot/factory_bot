require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "factory_bot", "~> 6.0"
  gem "activerecord"
  gem "sqlite3"
end

require "active_record"
require "factory_bot"
require "minitest/autorun"
require "logger"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  # TODO: Update the schema to include the specific tables or columns necessary
  # to reproduct the bug
  create_table :posts, force: true do |t|
    t.string :body
  end
end

# TODO: Add any application specific code necessary to reproduce the bug
class Post < ActiveRecord::Base
end

FactoryBot.define do
  # TODO: Write the factory definitions necessary to reproduce the bug
  factory :post do
    body { "Post body" }
  end
end

class FactoryBotTest < Minitest::Test
  def test_factory_bot_stuff
    # TODO: Write a failing test case to demonstrate what isn't working as
    # expected
    body_override = "Body override"

    post = FactoryBot.build(:post, body: body_override)

    assert_equal post.body, body_override
  end
end

# Run the tests with `ruby <filename>`
