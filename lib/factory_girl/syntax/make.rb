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
    #   User.make(:name => 'Johnny')
    #
    # This syntax was derived from Pete Yandell's machinist.
    module Make
      module ActiveRecord #:nodoc:

        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods #:nodoc:

          def make(overrides = {})
            FactoryRunner.new(name.underscore, Strategy::Build, [overrides]).run
          end

          def make!(overrides = {})
            FactoryRunner.new(name.underscore, Strategy::Create, [overrides]).run
          end

        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryGirl::Syntax::Make::ActiveRecord)
