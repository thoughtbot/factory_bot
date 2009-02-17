class Factory
  module Syntax #:nodoc:

    # Extends ActiveRecord::Base to provide a make class method, which is an
    # alternate syntax for defining factories.
    #
    # Usage:
    #
    #   require 'factory_girl/syntax/blueprint'
    #
    #   User.blueprint do
    #     name  { 'Billy Bob'             }
    #     email { 'billy@bob.example.com' }
    #   end
    #
    #   Factory(:user, :name => 'Johnny')
    module Blueprint
      module ActiveRecord #:nodoc:

        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods #:nodoc:

          def blueprint(&block)
            instance = Factory.new(name.underscore, :class => self)
            instance.instance_eval(&block)
            Factory.factories[instance.factory_name] = instance
          end

        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, Factory::Syntax::Blueprint::ActiveRecord)

