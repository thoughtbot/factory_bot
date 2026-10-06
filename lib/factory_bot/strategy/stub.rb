module FactoryBot
  module Strategy
    class Stub
      class << self
        attr_accessor :next_id
      end

      self.next_id = 1000

      def association(runner)
        runner.run(:build_stubbed)
      end

      def result(evaluation)
        evaluation.object.tap do |instance|
          instance.id ||= next_id(instance) if settable_id?(instance)
          instance.extend(Stubbed)
          set_timestamps(instance)
          instance.clear_changes_information if instance.respond_to?(:clear_changes_information)
          evaluation.notify(:after_stub, instance)
        end
      end

      def to_sym
        :build_stubbed
      end

      private

      def settable_id?(instance)
        instance.respond_to?(:id=) &&
          (!instance.class.respond_to?(:primary_key) || instance.class.primary_key)
      end

      def next_id(instance)
        uuid_primary_key?(instance) ? SecureRandom.uuid : (self.class.next_id += 1)
      end

      def uuid_primary_key?(instance)
        instance.respond_to?(:column_for_attribute) &&
          (column = instance.column_for_attribute(instance.class.primary_key)) &&
          column.respond_to?(:sql_type) &&
          column.sql_type == "uuid"
      end

      def set_timestamps(instance)
        timestamp = Time.current

        %i[created_at updated_at].each do |name|
          next unless instance.respond_to?(name) && instance.respond_to?(:"#{name}=")

          instance.public_send(:"#{name}=", timestamp) if instance.public_send(name).blank?
        end
      end
    end
  end
end
