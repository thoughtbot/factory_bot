module FactoryGirl
  class AttributeAssigner
    attr_reader :evaluator_class_instance

    def initialize(build_class, evaluator_class_instance, attribute_names_to_assign = [])
      @build_class               = build_class
      @evaluator_class_instance  = evaluator_class_instance
      @attribute_names_to_assign = attribute_names_to_assign
      @attribute_names_assigned  = []
    end

    def object
      build_class_instance.tap do |instance|
        (@attribute_names_to_assign - @attribute_names_assigned).each do |attribute|
          instance.send("#{attribute}=", get(attribute))
          @attribute_names_assigned << attribute
        end
      end
    end

    def hash
      @attribute_names_to_assign.inject({}) do |result, attribute|
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
  end
end
