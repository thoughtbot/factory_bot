module FactoryGirl
  module Syntax

    # Extends ActiveRecord::Base to provide generation methods for factories.
    #
    # Usage:
    #
    #   require 'factory_girl/syntax/generate'
    #
    #   FactoryGirl.define do
    #     factory :user do
    #       name 'Billy Bob'
    #       email 'billy@bob.example.com'
    #     end
    #   end
    #
    #   # Creates a saved instance without raising (same as saving the result
    #   # of FactoryGirl.build)
    #   User.generate(name: 'Johnny')
    #
    #   # Creates a saved instance and raises when invalid (same as
    #   # FactoryGirl.create)
    #   User.generate!
    #
    #   # Creates an unsaved instance (same as FactoryGirl.build)
    #   User.spawn
    #
    #   # Creates an instance and yields it to the passed block
    #   User.generate do |user|
    #     # ...do something with user...
    #   end
    #
    # This syntax was derived from Rick Bradley and Yossef Mendelssohn's
    # object_daddy.
    # @api private
    module Generate
      module ActiveRecord
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def generate(overrides = {}, &block)
            ActiveSupport::Deprecation.warn 'Model.generate is deprecated; use FactoryGirl.build(:name) instead.', caller
            instance = FactoryRunner.new(name.underscore, :build, [overrides]).run
            instance.save
            yield(instance) if block_given?
            instance
          end

          def generate!(overrides = {}, &block)
            ActiveSupport::Deprecation.warn 'Model.generate! is deprecated; use FactoryGirl.create(:name) instead.', caller
            instance = FactoryRunner.new(name.underscore, :create, [overrides]).run
            yield(instance) if block_given?
            instance
          end

          def spawn(overrides = {}, &block)
            ActiveSupport::Deprecation.warn 'Model.spawn is deprecated; use FactoryGirl.build(:name) instead.', caller
            instance = FactoryRunner.new(name.underscore, :build, [overrides]).run
            yield(instance) if block_given?
            instance
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryGirl::Syntax::Generate::ActiveRecord)
