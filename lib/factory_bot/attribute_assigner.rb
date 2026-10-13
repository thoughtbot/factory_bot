module FactoryBot
  # @api private
  class AttributeAssigner
    def initialize(evaluator, attributes, &instance_builder)
      @instance_builder = instance_builder
      @evaluator = evaluator
      @attributes = attributes
      @attribute_names_assigned = []
    end

    # constructs an object-based factory product
    def object
      @evaluator.instance = build_class_instance
      build_class_instance.tap do |instance|
        attributes_to_set_on_instance.each do |attribute|
          instance.public_send(:"#{attribute}=", get(attribute))
          @attribute_names_assigned << attribute
        end
      end
    end

    # constructs a Hash-based factory product
    def hash
      @evaluator.__hash_mode__!

      attributes_to_set_on_hash.each_with_object({}) do |attribute, result|
        result[attribute] = get(attribute)
      end
    end

    private

    def build_class_instance
      @build_class_instance ||= @evaluator.__construct__(attribute_names_to_assign, &@instance_builder)
    end

    def get(attribute_name)
      @evaluator.send(attribute_name)
    end

    # Attributes read by `initialize_with` are not assigned a second time
    def attributes_to_set_on_instance
      (attribute_names_to_assign - @attribute_names_assigned - @evaluator.__read_in_constructor__).uniq
    end

    def attributes_to_set_on_hash
      attribute_names_to_assign - association_names
    end

    # Builds a list of attributes names that should be assigned to the factory product
    def attribute_names_to_assign
      @attribute_names_to_assign ||= begin
        # start a list of candidates containing non-transient attributes and overrides
        assignment_candidates = non_transient_attribute_names + override_names
        # then remove any transient attributes (potentially reintroduced by the overrides),
        # and remove ignorable aliased attributes from the candidate list
        assignment_candidates - transient_attribute_names - attribute_names_overriden_by_alias
      end
    end

    def non_transient_attribute_names
      non_transient_attributes.map(&:name)
    end

    def transient_attribute_names
      @attributes.values.select(&:transient).map(&:name)
    end

    def association_names
      @attributes.values.select(&:association?).map(&:name)
    end

    def non_transient_attributes
      @attributes.values.reject(&:transient)
    end

    def override_names
      @evaluator.__override_names__
    end

    def attribute_names
      @attributes.keys
    end

    # Builds a list of attribute names which are slated to be interrupted by an override.
    def attribute_names_overriden_by_alias
      non_transient_attributes
        .flat_map { |attribute|
          override_names.map do |override|
            attribute.name if ignorable_alias?(attribute, override)
          end
        }
        .compact
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
      !override_matches_declared_attribute?(override)
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
      (aliased_attribute.association? || association_names.include?(override)) &&
        aliased_attribute.name != override
    end

    # Does this override match the name of any declared attribute?
    #
    # @note Checking against the names of all attributes, resolves any issues with having both
    #   <attribute> and <attribute>_id in the same factory. This also takes into account transient
    #   attributes that should not be assigned.
    #
    # @param [Symbol] override the name of an override
    def override_matches_declared_attribute?(override)
      attribute_names.include?(override)
    end
  end
end
