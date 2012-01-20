module FactoryGirl
  class AttributeAssigner
    def initialize(evaluator, &instance_builder)
      @instance_builder         = instance_builder
      @evaluator                = evaluator
      @attribute_list           = evaluator.class.attribute_list
      @attribute_names_assigned = []
    end

    def object
      @evaluator.instance = build_class_instance
      build_class_instance.tap do |instance|
        attributes_to_set_on_instance.each do |attribute|
          instance.send("#{attribute}=", get(attribute))
          @attribute_names_assigned << attribute
        end
      end
    end

    def hash
      @evaluator.instance = NullObject.new

      attributes_to_set_on_hash.inject({}) do |result, attribute|
        result[attribute] = get(attribute)
        result
      end
    end

    private

    def build_class_instance
      @build_class_instance ||= @evaluator.instance_exec(&@instance_builder)
    end

    def get(attribute_name)
      @evaluator.send(attribute_name)
    end

    def attributes_to_set_on_instance
      attribute_names_to_assign - @attribute_names_assigned
    end

    def attributes_to_set_on_hash
      attribute_names_to_assign - association_names
    end

    def attribute_names_to_assign
      non_ignored_attribute_names + override_names - ignored_attribute_names - alias_names_to_ignore
    end

    def non_ignored_attribute_names
      @attribute_list.reject(&:ignored).map(&:name)
    end

    def ignored_attribute_names
      @attribute_list.select(&:ignored).map(&:name)
    end

    def association_names
      @attribute_list.associations.map(&:name)
    end

    def override_names
      @evaluator.__overrides.keys
    end

    def alias_names_to_ignore
      @attribute_list.reject(&:ignored).map do |attribute|
        override_names.map {|override| attribute.name if attribute.alias_for?(override) && attribute.name != override }
      end.flatten.compact
    end
  end
end
