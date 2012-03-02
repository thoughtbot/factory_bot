module FactoryGirl
  module Syntax
    module Methods
      # Generates and returns a Hash of attributes from this factory. Attributes
      # can be individually overridden by passing in a Hash of attribute => value
      # pairs.
      #
      # Arguments:
      # * name: +Symbol+ or +String+
      #   The name of the factory that should be used.
      # * traits_and_overrides: +Array+
      #   [+*Array+] Traits to be applied
      #   [+Hash+] Attributes to overwrite for this set.
      # * block:
      #   Yields the hash of attributes.
      #
      # Returns: +Hash+
      # A set of attributes that can be used to build an instance of the class
      # this factory generates.
      def attributes_for(name, *traits_and_overrides, &block)
        FactoryRunner.new(name, Strategy::AttributesFor, traits_and_overrides).run(&block)
      end

      # Generates and returns an instance from this factory. Attributes can be
      # individually overridden by passing in a Hash of attribute => value pairs.
      #
      # Arguments:
      # * name: +Symbol+ or +String+
      #   The name of the factory that should be used.
      # * traits_and_overrides: +Array+
      #   [+*Array+] Traits to be applied
      #   [+Hash+] Attributes to overwrite for this instance.
      # * block:
      #   Yields the built instance.
      #
      # Returns: +Object+
      # An instance of the class this factory generates, with generated attributes
      # assigned.
      def build(name, *traits_and_overrides, &block)
        FactoryRunner.new(name, Strategy::Build, traits_and_overrides).run(&block)
      end

      # Generates, saves, and returns an instance from this factory. Attributes can
      # be individually overridden by passing in a Hash of attribute => value
      # pairs.
      #
      # Instances are saved using the +save!+ method, so ActiveRecord models will
      # raise ActiveRecord::RecordInvalid exceptions for invalid attribute sets.
      #
      # Arguments:
      # * name: +Symbol+ or +String+
      #   The name of the factory that should be used.
      # * traits_and_overrides: +Array+
      #   [+*Array+] Traits to be applied
      #   [+Hash+] Attributes to overwrite for this instance.
      # * block:
      #   Yields the created instance.
      #
      # Returns: +Object+
      # A saved instance of the class this factory generates, with generated
      # attributes assigned.
      def create(name, *traits_and_overrides, &block)
        FactoryRunner.new(name, Strategy::Create, traits_and_overrides).run(&block)
      end

      # Generates and returns an object with all attributes from this factory
      # stubbed out. Attributes can be individually overridden by passing in a Hash
      # of attribute => value pairs.
      #
      # Arguments:
      # * name: +Symbol+ or +String+
      #   The name of the factory that should be used.
      # * traits_and_overrides: +Array+
      #   [+*Array+] Traits to be applied
      #   [+Hash+] Attributes to overwrite for this instance.
      # * block
      #   Yields the stubbed object.
      #
      # Returns: +Object+
      # An object with generated attributes stubbed out.
      def build_stubbed(name, *traits_and_overrides, &block)
        FactoryRunner.new(name, Strategy::Stub, traits_and_overrides).run(&block)
      end

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
