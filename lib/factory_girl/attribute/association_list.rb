module FactoryGirl
  class Attribute #:nodoc:
    class AssociationList < Attribute  #:nodoc:
      attr_reader :factory

      def initialize(parent_factory_name, name, amount, factory, overrides)
        super(name, false)
        @parent_factory_name = parent_factory_name
        @factory = factory
        @amount = amount
        @overrides = overrides
      end

      def to_proc
        amount = @amount
        factory = @factory
        overrides = @overrides.reverse_merge(inverse_overrides)
        lambda { association_list(factory, amount, overrides) }
      end

      def association?
        true
      end

    protected

      attr_reader :parent_factory_name

      def parent_factory_class
        @parent_factory_class ||= FactoryGirl.factory_by_name(@parent_factory_name)
      end

      def parent_build_class
        @parent_build_class ||= parent_factory_class.build_class
      end

      def parent_reflection
        @parent_reflection ||= if parent_build_class.respond_to? :reflect_on_association
          parent_build_class.reflect_on_association(name)
        end
      end

      def factory_class
        @factory_class ||= FactoryGirl.factory_by_name(@factory)
      end

      def build_class
        @build_class ||= factory_class.build_class
      end

      def reflection
        @reflection ||= if build_class.respond_to? :reflect_on_association and parent_reflection and parent_reflection.macro == :has_many
          if parent_reflection.has_inverse?
            # Explicit inverse
            parent_reflection.inverse_of
          else
            # Implicit inverse
            # XXX: This should probably grab all belongs_to assocations and look at the key, not the name
            build_class.reflect_on_association(parent_reflection.foreign_key[0...-3].to_sym)
          end
        end
      end

      def inverse_overrides
        if reflection and reflection.macro == :belongs_to
          {reflection.name => nil}
        else
          {}
        end
      end
    end
  end
end
