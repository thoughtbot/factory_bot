module FactoryGirl
  class Linter < FactoryGirl::LinterBase

    private

    def calculate_invalid_factories
      factories_to_lint.reduce(Hash.new([])) do |result, factory|
        begin
          FactoryGirl.create(factory.name)
        rescue => error
          result[factory] |= [FactoryError.new(error, factory)]
        end
        result
      end
    end
  end
end
