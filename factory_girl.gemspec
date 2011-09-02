$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'factory_girl/version'
Gem::Specification.new do |s|
    s.name        = %q{factory_girl}
    s.version     = FactoryGirl::VERSION
    s.summary     = %q{factory_girl provides a framework and DSL for defining and
                       using model instance factories.}
    s.description = %q{factory_girl provides a framework and DSL for defining and
                       using factories - less error-prone, more explicit, and
                       all-around easier to work with than fixtures.}

    all_files       = %x{git ls-files}.split("\n").reject {|file| file =~ /gemspec/ }

    s.files         = all_files.reject {|file| file =~ /^(spec|features|cucumber|gemfiles|Appraisals)/ }
    s.test_files    = all_files.select {|file| file =~ /^(spec|features|cucumber|gemfiles|Appraisals)/ }

    s.require_path = 'lib'

    s.authors = ["Joe Ferris"]
    s.email   = %q{jferris@thoughtbot.com}
    s.homepage = "https://github.com/thoughtbot/factory_girl"

    s.add_development_dependency("rspec",    "~> 2.0")
    s.add_development_dependency("cucumber", "~> 1.0.0")
    s.add_development_dependency("timecop")
    s.add_development_dependency("rcov")
    s.add_development_dependency("aruba")
    s.add_development_dependency("mocha")
    s.add_development_dependency("bourne")
    s.add_development_dependency("appraisal", "~> 0.3.8")
    s.add_development_dependency("sqlite3-ruby")
    s.add_development_dependency("yard")
    s.add_development_dependency("bluecloth")

    s.platform = Gem::Platform::RUBY
    s.rubygems_version = %q{1.2.0}
end

