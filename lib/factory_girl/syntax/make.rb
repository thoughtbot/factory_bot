module FactoryGirl
  module Syntax

    # Extends ActiveRecord::Base to provide a make class method, which is a
    # shortcut for FactoryGirl.create.
    #
    # Usage:
    #
    # require 'factory_girl/syntax/make'
    #
    # FactoryGirl.define do
    # factory :user do
    # name 'Billy Bob'
    # email 'billy@bob.example.com'
    # end
    # end
    #
    # User.make(:name => 'Johnny')
    #
    # This syntax was derived from Pete Yandell's machinist.
    module Make
      module ActiveRecord #:nodoc:

        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods #:nodoc:

          def make(key_or_overrides = nil, overrides = {})
            key, overrides = make_options_from_args(key_or_overrides, overrides)
            FactoryGirl.find(key).run(Proxy::Build, overrides)
          end

          def make!(key_or_overrides = nil, overrides = {})
            key, overrides = make_options_from_args(key_or_overrides, overrides)
            FactoryGirl.find(key).run(Proxy::Create, overrides)
          end

          def make_options_from_args(key_or_overrides = nil, overrides = {})
            if key_or_overrides.nil?
              key = name.underscore
            elsif key_or_overrides.is_a?(Symbol)
              key = key_or_overrides
            else
              key = name.underscore
              overrides = key_or_overrides
            end

            [key, overrides]
          end
        end

      end
    end
  end
end

ActiveRecord::Base.send(:include, FactoryGirl::Syntax::Make::ActiveRecord)