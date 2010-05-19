$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'factory_girl'
Gem::Specification.new do |s|
    s.name        = %q{factory_girl}
    s.version     = Factory::VERSION
    s.summary     = %q{factory_girl provides a framework and DSL for defining and
                       using model instance factories.}
    s.description = %q{factory_girl provides a framework and DSL for defining and
                       using factories - less error-prone, more explicit, and
                       all-around easier to work with than fixtures.}

    s.files        = Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*.rb', 'features/**/*', 'rails/**/*']
    s.require_path = 'lib'
    s.test_files   = Dir['spec/**/*_spec.rb', 'features/**/*']

    s.has_rdoc         = true
    s.extra_rdoc_files = ["README.rdoc"]
    s.rdoc_options = ['--line-numbers', "--main", "README.rdoc"]

    s.authors = ["Joe Ferris"]
    s.email   = %q{jferris@thoughtbot.com}
    s.homepage = "http://thoughtbot.com/projects/factory_girl"

    s.add_development_dependency('rcov')
    s.add_development_dependency('rspec')
    s.add_development_dependency('cucumber')
    s.add_development_dependency('activerecord', '~>2.3.5')
    s.add_development_dependency('activerecord', '~>3.0.0.beta3')
    s.add_development_dependency('rr')
    s.add_development_dependency('sqlite3')

    s.platform = Gem::Platform::RUBY
    s.rubygems_version = %q{1.2.0}
end

