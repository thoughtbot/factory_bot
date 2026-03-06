---
type: note
created: 2026-03-06T16:14:00-06:00
updated: 2026-03-06T16:14:16-06:00
tags: []
aliases: []
up: "[[Setup]]"
---
# Adding FactoryBot to Your Gemfile

If you're using the Ruby on Rails framework, you'll want to add `factory_bot_rails` to your Gemfile:

```ruby
gem "factory_bot_rails"
```

If you're *not* using Rails, then we suggest adding `factory_bot`:

```ruby
gem "factory_bot"
```

After modifying your Gemfile, you'll want to run `bundle install`

For installation guidance on other frameworks, see [our wiki].

[our wiki]: https://github.com/thoughtbot/factory_bot/wiki/Installation
