# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{factory_girl}
  s.version = "1.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Ferris"]
  s.date = %q{2008-12-11}
  s.description = %q{factory_girl provides a framework and DSL for defining and using factories - less error-prone, more explicit, and  all-around easier to work with than fixtures.}
  s.email = %q{jferris@thoughtbot.com}
  s.extra_rdoc_files = ["README.textile"]
  s.files = ["Changelog", "CONTRIBUTION_GUIDELINES.rdoc", "LICENSE", "Rakefile", "README.textile", "lib/factory_girl/aliases.rb", "lib/factory_girl/attribute.rb", "lib/factory_girl/attribute_proxy.rb", "lib/factory_girl/factory.rb", "lib/factory_girl/sequence.rb", "lib/factory_girl.rb", "test/aliases_test.rb", "test/attribute_proxy_test.rb", "test/attribute_test.rb", "test/factory_test.rb", "test/integration_test.rb", "test/models.rb", "test/sequence_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.textile"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{factory_girl provides a framework and DSL for defining and using model instance factories.}
  s.test_files = ["test/aliases_test.rb", "test/attribute_proxy_test.rb", "test/attribute_test.rb", "test/factory_test.rb", "test/integration_test.rb", "test/sequence_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
