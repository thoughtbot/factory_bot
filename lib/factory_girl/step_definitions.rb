module FactoryGirlStepHelpers

  def convert_association_string_to_instance(factory_name, assignment)
    attribute, value = assignment.split(':', 2)
    return if value.blank?
    factory = FactoryGirl.factory_by_name(factory_name)
    attributes = convert_human_hash_to_attribute_hash({attribute => value.strip}, factory.associations)
    model_class = factory.build_class
    model_class.find(:first, :conditions => attributes) or
      FactoryGirl.create(factory_name, attributes)
  end

  def convert_human_hash_to_attribute_hash(human_hash, associations = [])
    human_hash.inject({}) do |attribute_hash, (human_key, value)|
      key = human_key.downcase.gsub(' ', '_').to_sym
      if association = associations.detect {|association| association.name == key }
        association_instance = convert_association_string_to_instance(association.factory, value)
        key = "#{key}_id"
        value = association_instance.id if association_instance
      end
      attribute_hash.merge(key => value)
    end
  end
end

World(FactoryGirlStepHelpers)

FactoryGirl.factories.each do |factory|
  Given /^the following (?:#{factory.human_name}|#{factory.human_name.pluralize}) exists?:$/i do |table|
    table.hashes.each do |human_hash|
      attributes = convert_human_hash_to_attribute_hash(human_hash, factory.associations)
      factory.run(FactoryGirl::Proxy::Create, attributes)
    end
  end

  Given /^an? #{factory.human_name} exists$/i do
    FactoryGirl.create(factory.name)
  end

  Given /^(\d+) #{factory.human_name.pluralize} exist$/i do |count|
    count.to_i.times { FactoryGirl.create(factory.name) }
  end

  if factory.build_class.respond_to?(:columns)
    factory.build_class.columns.each do |column|
      human_column_name = column.name.downcase.gsub('_', ' ')
      Given /^an? #{factory.human_name} exists with an? #{human_column_name} of "([^"]*)"$/i do |value|
        FactoryGirl.create(factory.name, column.name => value)
      end

      Given /^(\d+) #{factory.human_name.pluralize} exist with an? #{human_column_name} of "([^"]*)"$/i do |count, value|
        count.to_i.times { FactoryGirl.create(factory.name, column.name => value) }
      end
    end
  end
end

