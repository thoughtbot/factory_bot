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
      @attribute_names_to_assign ||=
        (@compiled.assignable_names + override_names - @compiled.transient_names - attribute_names_overriden_by_alias).uniq
    end

    def override_names
      @evaluator.__override_names__
    end

    # Builds a list of attribute names which are slated to be interrupted by an override.
    def attribute_names_overriden_by_alias
      @compiled.assignable_names.select do |name|
        override_names.any? { |override| ignorable_alias?(@compiled.attributes[name], override) }
      end
    end

    # Is the attribute an ignorable alias of the override?
    # An attribute is ignorable when it is an alias of the override AND it is
    # either interrupting an association OR is not the name of another attribute
    #
    # @note An "alias" is currently an overloaded term for two distinct cases:
    #   (1) attributes which are aliases and reference the same value
    #   (2) a logical grouping of a foreign key and an associated object
    def ignorable_alias?(attribute, override)
      return false unless attribute.alias_for?(override)

      # The attribute alias should be ignored when the override interrupts an association
      return true if override_interrupts_association?(attribute, override)

      # Remaining aliases should be ignored when the override does not match a declared attribute.
      # An override which is an alias to a declared attribute should not interrupt the aliased
      # attribute and interrupt only the attribute with a matching name. This workaround allows a
      # factory to declare both <attribute> and <attribute>_id as separate and distinct attributes.
      !@compiled.attributes.key?(override)
    end

    # Does this override interrupt an association?
    # When true, this indicates the aliased attribute is related to a declared association and the
    # override does not match the attribute name.
    #
    # @note Association overrides should take precedence over a declared foreign key attribute.
    #
    # @note An override may interrupt an association by providing the associated object or
    #   by providing the foreign key.
    #
    # @param [FactoryBot::Attribute] aliased_attribute
    # @param [Symbol] override name of an override which is an alias to the attribute name
    def override_interrupts_association?(aliased_attribute, override)
      (aliased_attribute.association? || @compiled.association_names.include?(override)) &&
        aliased_attribute.name != override
    end
  end
end
