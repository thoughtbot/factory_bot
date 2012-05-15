require 'observer'

module FactoryGirl
  class Evaluation
    include Observable

    def initialize(attribute_assigner, to_create)
      @attribute_assigner = attribute_assigner
      @to_create = to_create
    end

    delegate :object, :hash, :association_and_attribute_names, to: :@attribute_assigner

    def create(result_instance)
      @to_create[result_instance]
    end

    def notify(name, result_instance)
      changed
      notify_observers(name, result_instance)
    end
  end
end
