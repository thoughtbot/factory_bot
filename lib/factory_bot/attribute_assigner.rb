module FactoryBot
  # @api private
  class AttributeAssigner
    def initialize(compiled, evaluator)
      @compiled = compiled
      @evaluator = evaluator
    end

    # constructs an object-based factory product
    def object
      @object ||= begin
        instance = @evaluator.__construct__(attribute_names_to_assign, &@compiled.constructor)
        @evaluator.instance = instance

        # Attributes read by `initialize_with` are not assigned a second time
        (attribute_names_to_assign - @evaluator.__read_in_constructor__).each do |name|
          instance.public_send(:"#{name}=", get(name))
        end

        instance
      end
    end

    # constructs a Hash-based factory product
    def hash
      @evaluator.__hash_mode__!

      (attribute_names_to_assign - @compiled.association_names).to_h do |name|
        [name, get(name)]
      end
    end

    private

    def get(attribute_name)
      @evaluator.send(attribute_name)
    end

    # Declared attributes in declaration order, then undeclared overrides.
    def attribute_names_to_assign
      @attribute_names_to_assign ||= begin
        overrides = @evaluator.__override_names__
        ignored = overrides.flat_map { |override| aliases_ignored_for(override) }

        (@compiled.assignable_names + overrides - @compiled.transient_names - ignored).uniq
      end
    end

    # Declaring both <name> and <name>_id as plain attributes keeps them independent.
    def aliases_ignored_for(override)
      aliases = (FactoryBot.aliases_for(override) - [override]) & @compiled.assignable_names

      if @compiled.association_names.include?(override) || !@compiled.attributes.key?(override)
        aliases
      else
        aliases.select { |name| @compiled.attributes[name].association? }
      end
    end
  end
end
