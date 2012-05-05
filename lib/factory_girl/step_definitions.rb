# @api private
module FactoryGirlStepHelpers
  def convert_human_hash_to_attribute_hash(human_hash, associations = [])
    HumanHashToAttributeHash.new(human_hash, associations).attributes
  end

  class HumanHashToAttributeHash
    attr_reader :associations

    def initialize(human_hash, associations)
      @human_hash   = human_hash
      @associations = associations
    end

    def attributes(strategy = CreateAttributes)
      @human_hash.inject({}) do |attribute_hash, (human_key, value)|
        attributes = strategy.new(self, *process_key_value(human_key, value))
        attribute_hash.merge({ attributes.key => attributes.value })
      end
    end

    private

    def process_key_value(key, value)
      value = value.strip if value.is_a?(String)
      [key.downcase.gsub(' ', '_').to_sym, value]
    end

    class AssociationManager
      def initialize(human_hash_to_attributes_hash, key, value)
        @human_hash_to_attributes_hash = human_hash_to_attributes_hash
        @key   = key
        @value = value
      end

      def association
        @human_hash_to_attributes_hash.associations.detect {|association| association.name == @key }
      end

      def association_instance
        return unless association

        if attributes_hash = nested_attribute_hash
          factory.build_class.first(conditions: attributes_hash.attributes(FindAttributes)) or
          FactoryGirl.create(association.factory, attributes_hash.attributes)
        end
      end

      private

      def factory
        FactoryGirl.factory_by_name(association.factory)
      end

      def nested_attribute_hash
        attribute, value = @value.split(':', 2)
        return if value.blank?

        HumanHashToAttributeHash.new({ attribute => value }, factory.associations)
      end
    end

    class AttributeStrategy
      attr_reader :key, :value, :association_manager

      def initialize(human_hash_to_attributes_hash, key, value)
        @association_manager = AssociationManager.new(human_hash_to_attributes_hash, key, value)
        @key   = key
        @value = value
      end
    end

    class FindAttributes < AttributeStrategy
      def initialize(human_hash_to_attributes_hash, key, value)
        super

        if association_manager.association
          @key = "#{@key}_id"
          @value = association_manager.association_instance.try(:id)
        end
      end
    end

    class CreateAttributes < AttributeStrategy
      def initialize(human_hash_to_attributes_hash, key, value)
        super

        if association_manager.association
          @value = association_manager.association_instance
        end
      end
    end
  end
end

World(FactoryGirlStepHelpers)

FactoryGirl.factories.each do |factory|
  factory.compile
  factory.human_names.each do |human_name|
    attribute_names_for_model = if factory.build_class.respond_to?(:attribute_names)
      factory.build_class.attribute_names
    elsif factory.build_class.respond_to?(:columns)
      factory.build_class.columns.map do |column|
        column.respond_to?(:name) ? column.name : column.to_s
      end
    else
      []
    end

    Given /^the following (?:#{human_name}|#{human_name.pluralize}) exists?:?$/i do |table|
      table.hashes.each do |human_hash|
        attributes = convert_human_hash_to_attribute_hash(human_hash, factory.associations)
        FactoryGirl.create(factory.name, attributes)
      end
    end

    Given /^an? #{human_name} exists$/i do
      FactoryGirl.create(factory.name)
    end

    Given /^(\d+) #{human_name.pluralize} exist$/i do |count|
      FactoryGirl.create_list(factory.name, count.to_i)
    end

    attribute_names_for_model.each do |attribute_name|
      human_column_name = attribute_name.downcase.gsub('_', ' ')

      Given /^an? #{human_name} exists with an? #{human_column_name} of "([^"]*)"$/i do |value|
        FactoryGirl.create(factory.name, attribute_name => value)
      end

      Given /^(\d+) #{human_name.pluralize} exist with an? #{human_column_name} of "([^"]*)"$/i do |count, value|
        FactoryGirl.create_list(factory.name, count.to_i, attribute_name => value)
      end
    end
  end
end

