module FactoryGirl
  class AttributesModuleGenerator
    def initialize(attributes)
      @attributes = attributes
    end

    def to_module
      mod = Module.new

      @attributes.each do |attribute|
        mod.send :define_method, attribute.name do
          if @cached_attributes.key?(attribute.name)
            @cached_attributes[attribute.name]
          else
            @cached_attributes[attribute.name] = instance_exec(&attribute.to_proc)
          end
        end
      end

      mod
    end
  end
end
