Gem::Specification.new do |s|
  s.name        = %q{factory_girl_rails}
  s.version     = '1.0'
  s.summary     = %q{factory_girl_rails provides integration between
    factory_girl and rails 3}
  s.description = %q{factory_girl_rails provides integration between
    factory_girl and rails 3 (currently just automatic factory definition
    loading)}
  s.files        = Dir['[A-Z]*', 'lib/**/*.rb', 'spec/**/*.rb', 'features/**/*']
  s.require_path = 'lib'
  s.test_files   = Dir['spec/**/*_spec.rb', 'features/**/*']
  s.authors = ["Joe Ferris"]
  s.email   = %q{jferris@thoughtbot.com}
  s.homepage = "http://thoughtbot.com/projects/factory_girl_rails"
  s.add_runtime_dependency('rails', '>= 3.0.0.beta4')
  s.add_runtime_dependency('factory_girl', '~> 1.3')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('cucumber')
  s.platform = Gem::Platform::RUBY
  s.rubygems_version = %q{1.2.0}
end

