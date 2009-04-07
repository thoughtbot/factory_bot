$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rubygems'
gem 'thoughtbot-shoulda', ">= 2.0.0"

require 'test/unit'
require 'activerecord'

require 'spec'
require 'spec/interop/test'
require 'spec/autorun'
require 'rr'

require 'shoulda'
require 'shoulda/test_unit'
require 'models'

require 'factory_girl'

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end

class Test::Unit::TestCase
  def assert_received(subject, &block)
    block.call(received(subject)).call
  end
end

# This hack is currently necessary to get spec/interop to pick up #should statements
module Shoulda
  class Context
    def create_test_from_should_hash(should)
      test_name = ["test_", full_name, "should", "#{should[:name]}. "].flatten.join(' ').to_sym

      context = self
      test_unit_class.send(:define_method, test_name) do
        begin
          context.run_parent_setup_blocks(self)
          should[:before].bind(self).call if should[:before]
          context.run_current_setup_blocks(self)
          should[:block].bind(self).call
        ensure
          context.run_all_teardown_blocks(self)
        end
      end
    end
  end
end
