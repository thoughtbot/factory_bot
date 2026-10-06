module FactoryBot
  # What a strategy receives: it can ask for the built object or the attribute
  # hash, persist the object, and fire callbacks.
  class Evaluation
    def initialize(compiled, evaluator)
      @compiled = compiled
      @evaluator = evaluator
    end

    def object
      instance = @evaluator.__construct__(@compiled.constructor)
      names = assignable_names - @evaluator.__read_in_constructor__

      names.each do |name|
        instance.public_send(:"#{name}=", @evaluator.__read__(name))
      end

      instance
    end

    def hash
      @evaluator.__hash_mode__!
      associations = @compiled.attributes.values.select(&:association?).map(&:name)

      (assignable_names - associations).to_h { |name| [name, @evaluator.__read__(name)] }
    end

    def create(instance)
      to_create = @compiled.to_create
      (to_create.arity == 2) ? to_create.call(instance, @evaluator) : to_create.call(instance)
    end

    def notify(name, instance)
      @compiled.callbacks.each do |callback|
        callback.run(instance, @evaluator) if callback.name == name
      end
    end

    # Declared non-transient attributes in declaration order, then overrides
    # the factory never declared. An override also silences the attribute on
    # the other side of a foreign key: `user:` drops a declared `user_id`,
    # `user_id:` drops a declared `user` association.
    def self.assignable_names(attributes, override_names)
      declared = attributes.values
      names = declared.map(&:name)
      transient = declared.select(&:transient).map(&:name)
      associations = declared.select(&:association?).map(&:name)

      shadowed = declared.reject(&:transient).select { |attribute|
        override_names.any? do |override|
          next false unless foreign_key_pair?(attribute.name, override)

          interrupts_association = attribute.name != override &&
            (attribute.association? || associations.include?(override))
          interrupts_association || !names.include?(override)
        end
      }.map(&:name)

      ((names - transient) + override_names - transient - shadowed).uniq
    end

    def self.foreign_key_pair?(first, second)
      first == second || first == :"#{second}_id" || second == :"#{first}_id"
    end

    private

    def assignable_names
      self.class.assignable_names(@compiled.attributes, @evaluator.__override_names__)
    end
  end
end
