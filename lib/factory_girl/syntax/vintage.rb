module FactoryGirl
  module Syntax
    module Vintage
      module ::Factory
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
        #
        # Yields: +Factory+
        # The newly created factory.
        def self.define(name, options = {})
          $stderr.puts "DEPRECATION WARNING: Factory.define is deprecated; use the FactoryGirl.define block syntax to declare your factory."
          factory = FactoryGirl::Factory.new(name, options)
          proxy = FactoryGirl::DefinitionProxy.new(factory)
          yield(proxy)
          FactoryGirl.register_factory(factory)
        end

        # Defines a new sequence that can be used to generate unique values in a specific format.
        #
        # Arguments:
        #   name: (Symbol)
        #     A unique name for this sequence. This name will be referenced when
        #     calling next to generate new values from this sequence.
        #   block: (Proc)
        #     The code to generate each value in the sequence. This block will be
        #     called with a unique number each time a value in the sequence is to be
        #     generated. The block should return the generated value for the
        #     sequence.
        #
        # Example:
        #
        #   Factory.sequence(:email) {|n| "somebody_#{n}@example.com" }
        def self.sequence(name, start_value = 1, &block)
          $stderr.puts "DEPRECATION WARNING: Factory.sequence is deprecated; use the FactoryGirl.define block syntax to declare your sequence."
          FactoryGirl.register_sequence(Sequence.new(name, start_value, &block))
        end

        # Generates and returns the next value in a sequence.
        #
        # Arguments:
        #   name: (Symbol)
        #     The name of the sequence that a value should be generated for.
        #
        # Returns:
        #   The next value in the sequence. (Object)
        def self.next(name)
          $stderr.puts "DEPRECATION WARNING: Factory.next is deprecated; use FactoryGirl.generate instead."
          FactoryGirl.generate(name)
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
        #   Factory(:post, user_id: 1)
        def self.alias(pattern, replace)
          $stderr.puts "DEPRECATION WARNING: Factory.alias is deprecated; use FactoryGirl.aliases << [pattern, replace] instead."
          FactoryGirl.aliases << [pattern, replace]
        end

        # Alias for FactoryGirl.attributes_for
        def self.attributes_for(name, overrides = {})
          $stderr.puts "DEPRECATION WARNING: Factory.attributes_for is deprecated; use FactoryGirl.attributes_for instead."
          FactoryGirl.attributes_for(name, overrides)
        end

        # Alias for FactoryGirl.build
        def self.build(name, overrides = {})
          $stderr.puts "DEPRECATION WARNING: Factory.build is deprecated; use FactoryGirl.build instead."
          FactoryGirl.build(name, overrides)
        end

        # Alias for FactoryGirl.create
        def self.create(name, overrides = {})
          $stderr.puts "DEPRECATION WARNING: Factory.create is deprecated; use FactoryGirl.create instead."
          FactoryGirl.create(name, overrides)
        end

        # Alias for FactoryGirl.build_stubbed.
        def self.stub(name, overrides = {})
          $stderr.puts "DEPRECATION WARNING: Factory.stub is deprecated; use FactoryGirl.build_stubbed instead."
          FactoryGirl.build_stubbed(name, overrides)
        end
      end

      # Shortcut for Factory.create.
      #
      # Example:
      #   Factory(:user, name: 'Joe')
      def Factory(name, attrs = {})
        $stderr.puts "DEPRECATION WARNING: Factory(:name) is deprecated; use FactoryGirl.create(:name) instead."
        FactoryGirl.create(name, attrs)
      end
    end
  end
end

include FactoryGirl::Syntax::Vintage
