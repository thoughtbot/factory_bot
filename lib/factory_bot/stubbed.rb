module FactoryBot
  # Extended onto objects produced by build_stubbed: they report themselves as
  # persisted and refuse to touch the database.
  module Stubbed
    DISABLED_PERSISTENCE_METHODS = %i[
      connection
      decrement!
      delete
      destroy!
      destroy
      increment!
      reload
      save!
      save
      toggle!
      touch
      update!
      update
      update_attribute
      update_attributes!
      update_attributes
      update_column
      update_columns
    ].freeze

    def persisted?
      true
    end

    def new_record?
      false
    end

    def destroyed?
      false
    end

    DISABLED_PERSISTENCE_METHODS.each do |method_name|
      define_method(method_name) do |*args|
        raise "stubbed models are not allowed to access the database - " \
          "#{self.class}##{method_name}(#{args.join(",")})"
      end
    end
  end
end
