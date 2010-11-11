$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'rspec/autorun'
require 'rr'

require 'factory_girl'

module RR
  module Adapters
    module Rspec
      def self.included(mod)
        RSpec.configuration.backtrace_clean_patterns.push(RR::Errors::BACKTRACE_IDENTIFIER)
      end
    end
  end
end

RSpec.configure do |config|
  config.mock_framework = :rr
  RSpec::Core::ExampleGroup.send(:include, RR::Adapters::Rspec)
  config.after do
    FactoryGirl.factories.clear
    FactoryGirl.sequences.clear
  end
end

module DefinesConstants
  def self.included(example_group)
    example_group.class_eval do
      before do
        @defined_constants = []
      end

      after do
        @defined_constants.reverse.each do |path|
          namespace, class_name = *constant_path(path)
          namespace.send(:remove_const, class_name)
        end
      end

      def define_class(path, base = Object, &block)
        namespace, class_name = *constant_path(path)
        klass = Class.new(base)
        namespace.const_set(class_name, klass)
        klass.class_eval(&block) if block_given?
        @defined_constants << path
        klass
      end

      def constant_path(constant_name)
        names = constant_name.split('::')
        class_name = names.pop
        namespace = names.inject(Object) { |result, name| result.const_get(name) }
        [namespace, class_name]
      end
    end
  end
end

