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
    module Make
      module ActiveRecord #:nodoc:

        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods #:nodoc:

          def make(overrides = {})
            ActiveSupport::Deprecation.warn "Model.make is deprecated; use the FactoryGirl.define syntax instead", caller
            FactoryRunner.new(name.underscore, FactoryGirl.strategy_by_name(:build), [overrides]).run
          end

          def make!(overrides = {})
            ActiveSupport::Deprecation.warn "Model.make! is deprecated; use the FactoryGirl.define syntax instead", caller
            FactoryRunner.new(name.underscore, FactoryGirl.strategy_by_name(:create), [overrides]).run
          end

        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryGirl::Syntax::Make::ActiveRecord)
