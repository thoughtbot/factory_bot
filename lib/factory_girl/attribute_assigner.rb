module FactoryGirl
  class AttributeAssigner
    def initialize(build_class, evaluator_class_instance, attribute_list)
      @build_class              = build_class
      @evaluator_class_instance = evaluator_class_instance
      @attribute_list           = attribute_list
      @attribute_names_assigned = []
    end

    def object
      build_class_instance.tap do |instance|
        attributes_to_set_on_instance.each do |attribute|
          instance.send("#{attribute}=", get(attribute))
          @attribute_names_assigned << attribute
        end
      end
    end

    def hash
      attribute_names_to_assign.inject({}) do |result, attribute|
        result[attribute] = get(attribute)
        result
      end
    end

    private

    def build_class_instance
      @build_class_instance ||= @build_class.new
    end

    def get(attribute_name)
      @evaluator_class_instance.send(attribute_name)
    end

    def attributes_to_set_on_instance
      attribute_names_to_assign - @attribute_names_assigned
    end

    def attribute_names_to_assign
      non_ignored_attribute_names = @attribute_list.reject(&:ignored).map(&:name)
      ignored_attribute_names     = @attribute_list.select(&:ignored).map(&:name)
      override_names              = @evaluator_class_instance.instance_variable_get(:@overrides).keys
      non_ignored_attribute_names + override_names - ignored_attribute_names
    end
  end
end
