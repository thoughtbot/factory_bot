$LOAD_PATH << File.expand_path("../lib", __FILE__)
require 'factory_girl/version'

Gem::Specification.new do |s|
  s.name        = %q{factory_girl}
  s.version     = FactoryGirl::VERSION
  s.summary     = %q{factory_girl provides a framework and DSL for defining and
                      using model instance factories.}
  s.description = %q{factory_girl provides a framework and DSL for defining and
                      using factories - less error-prone, more explicit, and
                      all-around easier to work with than fixtures.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- Appraisals {spec,features,gemfiles}/*`.split("\n")

  s.require_paths = ['lib']
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.authors = ["Josh Clayton", "Joe Ferris"]
  s.email   = ["jclayton@thoughtbot.com", "jferris@thoughtbot.com"]

  s.homepage = "https://github.com/thoughtbot/factory_girl"

  s.add_dependency("activesupport", ">= 3.0.0")

  s.add_development_dependency("rspec",    "~> 2.0")
  s.add_development_dependency("cucumber", "~> 1.1")
  s.add_development_dependency("timecop")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("aruba")
  s.add_development_dependency("mocha")
  s.add_development_dependency("bourne")
  s.add_development_dependency("appraisal", "~> 0.4")
  s.add_development_dependency("sqlite3-ruby")
  s.add_development_dependency("yard")
  s.add_development_dependency("bluecloth")
end

