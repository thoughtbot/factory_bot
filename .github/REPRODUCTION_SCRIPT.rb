require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"
  git_source(:github) { |repo| "https://github.com/#{repo}.git" }
  gem "factory_bot", "~> 5.0"
end

require "factory_bot"
require "minitest/autorun"

class Post
  attr_accessor :body
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
