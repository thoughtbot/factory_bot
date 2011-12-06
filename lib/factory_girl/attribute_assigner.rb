module FactoryGirl
  class AttributeAssigner
    def initialize(build_class, evaluator, attribute_list)
      @build_class              = build_class
      @evaluator                = evaluator
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
      attributes_to_set_on_hash.inject({}) do |result, attribute|
        result[attribute] = get(attribute)
        result
      end
    end

    private

    def build_class_instance
      @build_class_instance ||= @build_class.new
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
      override_names = @evaluator.__overrides.keys
      non_ignored_attribute_names + override_names - ignored_attribute_names
    end

    def non_ignored_attribute_names
      @attribute_list.reject(&:ignored).map(&:name)
    end

    def ignored_attribute_names
      @attribute_list.select(&:ignored).map(&:name)
    end

    def association_names
      @attribute_list.select(&:association?).map(&:name)
    end
  end
end
