$LOAD_PATH << File.expand_path("../lib", __FILE__)
require "factory_bot/version"

Gem::Specification.new do |s|
  s.name        = "factory_bot"
  s.version     = FactoryBot::VERSION
  s.summary     = "factory_bot provides a framework and DSL for defining and "\
                  "using model instance factories."
  s.description = "factory_bot provides a framework and DSL for defining and "\
                  "using factories - less error-prone, more explicit, and "\
                  "all-around easier to work with than fixtures."

  s.files =
    Dir.glob("lib/**/*") +
    %w[CONTRIBUTING.md GETTING_STARTED.md LICENSE NAME.md NEWS README.md]

  s.require_path = "lib"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.authors = ["Josh Clayton", "Joe Ferris"]
  s.email   = ["jclayton@thoughtbot.com", "jferris@thoughtbot.com"]

  s.homepage = "https://github.com/thoughtbot/factory_bot"

  s.add_dependency("activesupport", ">= 3.0.0")

  s.add_development_dependency("activerecord", ">= 3.0.0")
  s.add_development_dependency("appraisal", "~> 2.1.0")
  s.add_development_dependency("aruba")
  s.add_development_dependency("cucumber", "~> 1.3.15")
  s.add_development_dependency("rspec",    "~> 3.0")
  s.add_development_dependency("rspec-its", "~> 1.0")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("timecop")
  s.add_development_dependency("yard")

  s.license = "MIT"
end
