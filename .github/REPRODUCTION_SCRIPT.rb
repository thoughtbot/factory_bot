require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "factory_bot", "~> 5.0"
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
  create_table :posts, force: true do |t|
    t.string :body
  end
end

class Post < ActiveRecord::Base
end

FactoryBot.define do
  factory :post do
    body { "Post body" }
  end
end

class FactoryBotTest < Minitest::Test
  def test_factory_bot_stuff
    body_override = "Body override"

    post = FactoryBot.build(:post, body: body_override)

    assert_equal post.body, body_override
  end
end
