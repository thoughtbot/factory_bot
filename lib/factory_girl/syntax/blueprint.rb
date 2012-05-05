module FactoryGirl
  module Syntax

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
    #   FactoryGirl.create(:user, name: 'Johnny')
    #
    # This syntax was derived from Pete Yandell's machinist.
    # @api private
    module Blueprint
      module ActiveRecord
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def blueprint(&block)
            ActiveSupport::Deprecation.warn 'Model.blueprint is deprecated; use the FactoryGirl.define syntax instead', caller
            instance = Factory.new(name.underscore, class: self)
            proxy = FactoryGirl::DefinitionProxy.new(instance)
            proxy.instance_eval(&block)
            FactoryGirl.register_factory(instance)
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryGirl::Syntax::Blueprint::ActiveRecord)
