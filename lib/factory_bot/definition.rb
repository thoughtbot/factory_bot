module FactoryBot
  # @api private
  class Definition
    attr_reader :defined_traits, :declarations, :name, :registered_enums, :uri_manager
    attr_accessor :klass

    def initialize(name, base_traits = [], **opts)
      @name = name
      @uri_manager = opts[:uri_manager]
      @declarations = DeclarationList.new(name)
      @callbacks = []
      @defined_traits = Set.new
      @registered_enums = []
      @to_create = nil
      @base_traits = base_traits
      @constructor = nil
      @compiled = false
      @expanded_enum_traits = false
    end

    delegate :declare_attribute, to: :declarations

    def attributes
      AttributeList.new.tap do |attribute_list|
        attribute_lists = aggregate_from_traits_and_self(:attributes) { declarations.attributes }
        attribute_lists.each do |attributes|
          attribute_list.apply_attributes attributes
        end
      end
    end

    def to_create(&block)
      if block
        @to_create = block
      else
        aggregate_from_traits_and_self(:to_create) { @to_create }.last
      end
    end

    def constructor
      aggregate_from_traits_and_self(:constructor) { @constructor }.last
    end

    def callbacks
      aggregate_from_traits_and_self(:callbacks) { @callbacks }
    end

    def compile(klass = nil)
      unless @compiled
        ActiveSupport::Notifications.instrument "factory_bot.compile_factory", {name: name} do |payload|
          expand_enum_traits(klass) unless klass.nil?

          declarations.attributes

          self.klass ||= klass
          defined_traits.each { |defined_trait| defined_trait.klass ||= klass }

          @compiled = true

          payload[:attributes] = declarations.attributes
          payload[:traits] = defined_traits
          payload[:class] = klass || self.klass
        end
      end
    end

    def overridable
      declarations.overridable
      self
    end

    def inherit_traits(new_traits)
      @base_traits |= new_traits
    end

    def add_callback(callback)
      @callbacks << callback
    end

    def skip_create
      @to_create = ->(instance) {}
    end

    def define_trait(trait)
      @defined_traits.add(trait)
      @defined_traits_by_name = nil
    end

    def defined_traits_names
      @defined_traits.map(&:name)
    end

    def register_enum(enum)
      @registered_enums << enum
    end

    def define_constructor(&block)
      @constructor = block
    end

    def before(*names, &block)
      callback(*names.map { |name| "before_#{name}" }, &block)
    end

    def after(*names, &block)
      callback(*names.map { |name| "after_#{name}" }, &block)
    end

    def callback(*names, &block)
      names.each do |name|
        add_callback(Callback.new(name, block))
      end
    end

    # Resolves trait names in this definition's scope and lets each trait's
    # body resolve this definition's traits by name in turn.
    def lookup_traits(names)
      names.map { |name| trait_by_name(name) }.each do |trait|
        defined_traits.each { |defined_trait| trait.define_trait(defined_trait) }
      end
    rescue KeyError => error
      raise error_with_definition_name(error)
    end

    private

    def base_traits
      lookup_traits(@base_traits)
    end

    def all_registered_trait_names
      (defined_traits_names + Internal.traits.map(&:name)).uniq
    end

    def error_options(error)
      if error.respond_to?(:key) && error.respond_to?(:receiver)
        receiver = error.receiver
        if receiver.is_a?(Hash) || receiver.is_a?(ActiveSupport::HashWithIndifferentAccess)
          receiver = receiver.dup
          defined_traits_names.each do |trait_name|
            receiver[trait_name] = nil unless receiver.key?(trait_name)
          end
        end
        {key: error.key, receiver: receiver}
      else
        {}
      end
    end

    # Before Ruby 3.2, did_you_mean embeds its suggestions in the message itself.
    def original_message(error)
      error.message.partition("\nDid you mean?").first
    end

    def registered_trait_message(all_registered_traits)
      if all_registered_traits.empty?
        "No registered traits"
      else
        "Registered traits: #{all_registered_traits.map(&:to_sym).sort.inspect}"
      end
    end

    def error_with_definition_name(error)
      message = original_message(error).rstrip
      message += "." unless message.end_with?(".")
      message += " #{registered_trait_message(all_registered_trait_names)}."
      message += " Referenced within \"#{name}\" definition"

      new_error(error, message).tap { |new_error| new_error.set_backtrace(error.backtrace) }
    end

    # detailed_message introduced in Ruby 3.2 for cleaner integration with
    # did_you_mean. See https://bugs.ruby-lang.org/issues/18564
    if KeyError.method_defined?(:detailed_message)
      def new_error(error, message)
        error.class.new(message, **error_options(error))
      end
    else
      # Embed the suggestions so Exception#original_message includes them too.
      def new_error(error, message)
        options = error_options(error)
        error.class.new(error.class.new(message, **options).message, **options)
      end
    end

    def trait_by_name(name)
      trait_for(name) || Internal.trait_by_name(name, klass)
    end

    def trait_for(name)
      @defined_traits_by_name ||= defined_traits.each_with_object({}) { |t, memo| memo[t.name] ||= t }
      @defined_traits_by_name[name.to_s]
    end

    def aggregate_from_traits_and_self(method_name, &block)
      compile

      [
        base_traits.map(&method_name),
        instance_exec(&block)
      ].flatten.compact
    end

    def expand_enum_traits(klass)
      return if @expanded_enum_traits

      if automatically_register_defined_enums?(klass)
        automatically_register_defined_enums(klass)
      end

      registered_enums.each do |enum|
        traits = enum.build_traits(klass)
        traits.each { |trait| define_trait(trait) }
      end

      @expanded_enum_traits = true
    end

    def automatically_register_defined_enums(klass)
      klass.defined_enums.each_key { |name| register_enum(Enum.new(name)) }
    end

    def automatically_register_defined_enums?(klass)
      FactoryBot.automatically_define_enum_traits &&
        klass.respond_to?(:defined_enums)
    end
  end
end
