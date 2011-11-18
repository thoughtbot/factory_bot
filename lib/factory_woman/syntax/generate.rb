module FactoryWoman
  module Syntax

    # Extends ActiveRecord::Base to provide generation methods for factories.
    #
    # Usage:
    #
    #   require 'factory_girl/syntax/generate'
    #
    #   FactoryWoman.define do
    #     factory :user do
    #       name 'Billy Bob'
    #       email 'billy@bob.example.com'
    #     end
    #   end
    #
    #   # Creates a saved instance without raising (same as saving the result
    #   # of FactoryWoman.build)
    #   User.generate(:name => 'Johnny')
    #
    #   # Creates a saved instance and raises when invalid (same as
    #   # FactoryWoman.create)
    #   User.generate!
    #
    #   # Creates an unsaved instance (same as FactoryWoman.build)
    #   User.spawn
    #
    #   # Creates an instance and yields it to the passed block
    #   User.generate do |user|
    #     # ...do something with user...
    #   end
    #
    # This syntax was derived from Rick Bradley and Yossef Mendelssohn's
    # object_daddy.
    module Generate
      module ActiveRecord #:nodoc:

        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods #:nodoc:

          def generate(overrides = {}, &block)
            factory = FactoryWoman.factory_by_name(name.underscore)
            instance = factory.run(Proxy::Build, overrides)
            instance.save
            yield(instance) if block_given?
            instance
          end

          def generate!(overrides = {}, &block)
            factory = FactoryWoman.factory_by_name(name.underscore)
            instance = factory.run(Proxy::Create, overrides)
            yield(instance) if block_given?
            instance
          end

          def spawn(overrides = {}, &block)
            factory = FactoryWoman.factory_by_name(name.underscore)
            instance = factory.run(Proxy::Build, overrides)
            yield(instance) if block_given?
            instance
          end

        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryWoman::Syntax::Generate::ActiveRecord)
