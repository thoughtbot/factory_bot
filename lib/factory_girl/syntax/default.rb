module FactoryGirl
  module Syntax
    module Default
      module Factory
        # Defines a new factory that can be used by the build strategies (create and
        # build) to build new objects.
        #
        # Arguments:
        # * name: +Symbol+ or +String+
        #   A unique name used to identify this factory.
        # * options: +Hash+
        #
        # Options:
        # * class: +Symbol+, +Class+, or +String+
        #   The class that will be used when generating instances for this factory. If not specified, the class will be guessed from the factory name.
        # * parent: +Symbol+
        #   The parent factory. If specified, the attributes from the parent
        #   factory will be copied to the current one with an ability to override
        #   them.
        # * default_strategy: +Symbol+
        #   The strategy that will be used by the Factory shortcut method.
        #   Defaults to :create.
        #
        # Yields: +Factory+
        # The newly created factory.
        def self.define(name, options = {})
          factory = FactoryGirl::Factory.new(name, options)
          proxy = FactoryGirl::DefinitionProxy.new(factory)
          yield(proxy)
          if parent = options.delete(:parent)
            factory.inherit_from(FactoryGirl.factory_by_name(parent))
          end
          FactoryGirl.register_factory(factory)
        end

        # Generates and returns a Hash of attributes from this factory. Attributes
        # can be individually overridden by passing in a Hash of attribute => value
        # pairs.
        #
        # Arguments:
        # * name: +Symbol+ or +String+
        #   The name of the factory that should be used.
        # * overrides: +Hash+
        #   Attributes to overwrite for this set.
        #
        # Returns: +Hash+
        # A set of attributes that can be used to build an instance of the class
        # this factory generates.
        def self.attributes_for(name, overrides = {})
          FactoryGirl.factory_by_name(name).run(Proxy::AttributesFor, overrides)
        end

        # Generates and returns an instance from this factory. Attributes can be
        # individually overridden by passing in a Hash of attribute => value pairs.
        #
        # Arguments:
        # * name: +Symbol+ or +String+
        #   The name of the factory that should be used.
        # * overrides: +Hash+
        #   Attributes to overwrite for this instance.
        #
        # Returns: +Object+
        # An instance of the class this factory generates, with generated attributes
        # assigned.
        def self.build(name, overrides = {})
          FactoryGirl.factory_by_name(name).run(Proxy::Build, overrides)
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
        # * overrides: +Hash+
        #   Attributes to overwrite for this instance.
        #
        # Returns: +Object+
        # A saved instance of the class this factory generates, with generated
        # attributes assigned.
        def self.create(name, overrides = {})
          FactoryGirl.factory_by_name(name).run(Proxy::Create, overrides)
        end

        # Generates and returns an object with all attributes from this factory
        # stubbed out. Attributes can be individually overridden by passing in a Hash
        # of attribute => value pairs.
        #
        # Arguments:
        # * name: +Symbol+ or +String+
        #   The name of the factory that should be used.
        # * overrides: +Hash+
        #   Attributes to overwrite for this instance.
        #
        # Returns: +Object+
        # An object with generated attributes stubbed out.
        def self.stub(name, overrides = {})
          FactoryGirl.factory_by_name(name).run(Proxy::Stub, overrides)
        end

        # Executes the default strategy for the given factory. This is usually create,
        # but it can be overridden for each factory.
        #
        # Arguments:
        # * name: +Symbol+ or +String+
        #   The name of the factory that should be used.
        # * overrides: +Hash+
        #   Attributes to overwrite for this instance.
        #
        # Returns: +Object+
        # The result of the default strategy.
        def self.default_strategy(name, overrides = {})
          self.send(FactoryGirl.factory_by_name(name).default_strategy, name, overrides)
        end

        # Defines a new sequence that can be used to generate unique values in a specific format.
        #
        # Arguments:
        #   name: (Symbol)
        #     A unique name for this sequence. This name will be referenced when
        #     calling next to generate new values from this sequence.
        #   start_value: +Integer+ or +String+
        #     The starting value for this sequence. Any object that responds to 
        #     +next+ will work.
        #     Defaults to 1.
        #   block: (Proc)
        #     The code to generate each value in the sequence. This block will be
        #     called with a unique value each time an item in the sequence is to be
        #     generated. The block should return the generated value for the
        #     sequence.
        #
        # Example:
        #
        #   Factory.sequence(:email) {|n| "somebody_#{n}@example.com" }
        #   Factory.sequence(:product_code, "AAAA") {|s| "PC-#{s}" }
        def self.sequence(name, start_value = 1, &block)
          FactoryGirl.sequences[name] = Sequence.new(start_value, &block)
        end

        # Generates and returns the next value in a sequence.
        #
        # Arguments:
        #   name: (Symbol)
        #     The name of the sequence that a value should be generated for.
        #
        # Returns:
        #   The next value in the sequence. (Object)
        def self.next(sequence)
          unless FactoryGirl.sequences.key?(sequence)
            raise "No such sequence: #{sequence}"
          end

          FactoryGirl.sequences[sequence].next
        end

        # Defines a new alias for attributes.
        #
        # Arguments:
        # * pattern: +Regexp+
        #   A pattern that will be matched against attributes when looking for
        #   aliases. Contents captured in the pattern can be used in the alias.
        # * replace: +String+
        #   The alias that results from the matched pattern. Captured strings can
        #   be substituted like with +String#sub+.
        #
        # Example:
        #
        #   Factory.alias /(.*)_confirmation/, '\1'
        #
        # factory_girl starts with aliases for foreign keys, so that a :user
        # association can be overridden by a :user_id parameter:
        #
        #   Factory.define :post do |p|
        #     p.association :user
        #   end
        #
        #   # The user association will not be built in this example. The user_id
        #   # will be used instead.
        #   Factory(:post, :user_id => 1)
        def self.alias(pattern, replace)
          FactoryGirl.aliases << [pattern, replace]
        end

      end

      # Shortcut for Factory.default_strategy.
      #
      # Example:
      #   Factory(:user, :name => 'Joe')
      def Factory(name, attrs = {})
        Factory.default_strategy(name, attrs)
      end
    end
  end
end

include FactoryGirl::Syntax::Default
