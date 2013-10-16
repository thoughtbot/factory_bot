module FactoryGirl
  class HashModuleGenerator
    def initialize(hash)
      @hash = hash
    end

    def to_module
      mod = Module.new

      @hash.each do |key, value|
        mod.send :define_method, key do
          if @cached_attributes.key?(key)
            @cached_attributes[key]
          else
            @cached_attributes[key] = value
          end
        end
      end

      mod
    end
  end
end
