module FactoryBot
  # A bare word in a definition block (`admin`), resolved by the Compiler into
  # an association, a sequence attribute, or a trait reference.
  Implicit = Data.define(:name, :transient) do
    def initialize(name:, transient: false)
      super(name: name.to_sym, transient: transient)
    end
  end
end
