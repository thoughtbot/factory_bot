module FactoryGirl
  class LinterWithTraits < LinterBase

    private

    class FactoryTraitError < FactoryError
      def initialize(wrapped_error, factory, trait_name)
        super(wrapped_error, factory)
        @trait_name = trait_name
      end

      def location
        "#{@factory.name}+#{@trait_name}"
      end
    end

    def calculate_invalid_factories
      factories_to_lint.reduce(Hash.new([])) do |result, factory|
        begin
          FactoryGirl.create(factory.name)
        rescue => error
          result[factory] |= [FactoryError.new(error, factory)]
        end

        factory.definition.defined_traits.map(&:name).each do |trait_name|
          begin
            FactoryGirl.create(factory.name, trait_name)
          rescue => error
            result[factory] |=
                [FactoryTraitError.new(error, factory, trait_name)]
          end
        end
        result
      end
    end
  end
end