module FactoryGirl
  class Attribute #:nodoc:

    class Trait < Attribute #:nodoc:
      def initialize(name, factory)
        super(name)
        @factory = factory
      end

      def add_to(proxy)
        trait.attributes.each { |attr| attr.add_to(proxy) }
      end

      private

      def trait
        (@factory || FactoryGirl).trait_by_name(name)
      end
    end

  end
end
