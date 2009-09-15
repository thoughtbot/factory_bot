module FactoryGirlStepHelpers
  def convert_ast_table_to_attribute_hash(table)
    table.rows.inject({}) do |result, (human_key, value)|
      key = human_key.downcase.gsub(' ', '_').to_sym
      result.merge(key => value)
    end
  end
end

World(FactoryGirlStepHelpers)

Factory.factories.values.each do |factory|
  Given "the following #{factory.human_name} exists:" do |table|
    attributes = convert_ast_table_to_attribute_hash(table)
    Factory.create(factory.factory_name, attributes)
  end
end

