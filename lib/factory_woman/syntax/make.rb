module FactoryWoman
  module Syntax

    # Extends ActiveRecord::Base to provide a make class method, which is a
    # shortcut for FactoryWoman.create.
    #
    # Usage:
    #
    #   require 'factory_girl/syntax/make'
    #
    #   FactoryWoman.define do
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
            FactoryWoman.factory_by_name(name.underscore).run(Proxy::Build, overrides)
          end

          def make!(overrides = {})
            FactoryWoman.factory_by_name(name.underscore).run(Proxy::Create, overrides)
          end

        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryWoman::Syntax::Make::ActiveRecord)
