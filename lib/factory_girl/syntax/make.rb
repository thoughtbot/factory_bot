class Factory
  module Syntax #:nodoc:

    # Extends ActiveRecord::Base to provide a make class method, which is a
    # shortcut for Factory.create.
    #
    # Usage:
    #
    #   require 'factory_girl/syntax/make'
    #   
    #   Factory.define :user do |factory|
    #     factory.name 'Billy Bob'
    #     factory.email 'billy@bob.example.com'
    #   end
    #
    #   User.make(:name => 'Johnny')
    module Make
      module ActiveRecord #:nodoc:

        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods #:nodoc:

          def make(overrides = {})
            Factory.create(name.underscore, overrides)
          end

        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, Factory::Syntax::Make::ActiveRecord)
