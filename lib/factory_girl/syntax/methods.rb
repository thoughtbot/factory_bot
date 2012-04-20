module FactoryGirl
  module Syntax
    module Methods
      # Builds and returns multiple instances from this factory as an array. Attributes can be
      # individually overridden by passing in a Hash of attribute => value pairs.
      #
      # Arguments:
      # * name: +Symbol+ or +String+
      #   The name of the factory to be used.
      # * amount: +Integer+
      #   number of instances to be built.
      # * traits_and_overrides: +Array+
      #   [+*Array+] Traits to be applied
      #   [+Hash+] Attributes to overwrite for this instance.
      #
      # Returns: +Array+
      # An array of instances of the class this factory generates, with generated attributes
      # assigned.
      def build_list(name, amount, *traits_and_overrides)
        amount.times.map { build(name, *traits_and_overrides) }
      end

      # Creates and returns multiple instances from this factory as an array. Attributes can be
      # individually overridden by passing in a Hash of attribute => value pairs.
      #
      # Arguments:
      # * name: +Symbol+ or +String+
      #   The name of the factory to be used.
      # * amount: +Integer+
      #   number of instances to be created.
      # * traits_and_overrides: +Array+
      #   [+*Array+] Traits to be applied
      #   [+Hash+] Attributes to overwrite for this instance.
      #
      # Returns: +Array+
      # An array of instances of the class this factory generates, with generated attributes
      # assigned.
      def create_list(name, amount, *traits_and_overrides)
        amount.times.map { create(name, *traits_and_overrides) }
      end

      # Generates and returns the next value in a sequence.
      #
      # Arguments:
      #   name: (Symbol)
      #     The name of the sequence that a value should be generated for.
      #
      # Returns:
      #   The next value in the sequence. (Object)
      def generate(name)
        FactoryGirl.sequence_by_name(name).next
      end
    end
  end
end
