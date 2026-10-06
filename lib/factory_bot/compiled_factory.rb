module FactoryBot
  # The result of compiling a factory with a set of runtime traits: everything
  # a run needs, with precedence already applied. Immutable and cached.
  CompiledFactory = Data.define(:factory, :build_class, :attributes, :callbacks, :constructor, :to_create, :traits)
end
