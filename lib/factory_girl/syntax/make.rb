module FactoryGirl
  module Syntax

    # Extends ActiveRecord::Base to provide a make class method, which is a
    # shortcut for FactoryGirl.create.
    #
    # Usage:
    #
    #   require 'factory_girl/syntax/make'
    #
    #   FactoryGirl.define do
    #     factory :user do
    #       name 'Billy Bob'
    #       email 'billy@bob.example.com'
    #     end
    #   end
    #
    #   User.make(name: 'Johnny')
    #
    # This syntax was derived from Pete Yandell's machinist.
    # @api private
    module Make
      module ActiveRecord
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def make(overrides = {})
            ActiveSupport::Deprecation.warn 'Model.make is deprecated; use FactoryGirl.build(:model) instead.', caller
            FactoryRunner.new(name.underscore, :build, [overrides]).run
          end

          def make!(overrides = {})
            ActiveSupport::Deprecation.warn 'Model.make! is deprecated; use FactoryGirl.create(:model) instead.', caller
            FactoryRunner.new(name.underscore, :create, [overrides]).run
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryGirl::Syntax::Make::ActiveRecord)
