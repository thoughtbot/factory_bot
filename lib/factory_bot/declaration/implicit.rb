module FactoryBot
  class Declaration
    # @api private
    class Implicit < Declaration
      def ==(other)
        self.class == other.class &&
          name == other.name &&
          transient == other.transient
      end
    end
  end
end
