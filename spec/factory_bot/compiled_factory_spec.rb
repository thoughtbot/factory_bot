describe FactoryBot::CompiledFactory do
  def register_factory(name, options = {}, &block)
    factory = FactoryBot::Factory.new(name, options)
    FactoryBot::DefinitionProxy.new(factory.definition).instance_eval(&block) if block
    FactoryBot::Internal.register_factory(factory)
  end

  def compiled_factory(factory, traits = [])
    FactoryBot::Internal.compiled_factory(factory, traits)
  end

  describe "caching" do
    it "returns the same snapshot for a factory and trait list" do
      define_class("User") { attr_accessor :admin }
      factory = register_factory(:user) do
        trait(:admin) { admin { true } }
      end

      compiled = compiled_factory(factory, [:admin])

      expect(compiled_factory(factory, ["admin"])).to equal compiled
      expect(compiled_factory(factory, [])).not_to equal compiled
    end

    it "is dropped by FactoryBot.define" do
      define_class("User")
      factory = register_factory(:user)
      compiled = compiled_factory(factory)

      FactoryBot.define { sequence(:email) }

      expect(compiled_factory(factory)).not_to equal compiled
    end

    it "is dropped by FactoryBot.modify" do
      define_class("User") { attr_accessor :name }
      factory = register_factory(:user)
      compiled = compiled_factory(factory)

      FactoryBot.modify do
        factory(:user) { name { "Modified" } }
      end

      expect(compiled_factory(factory)).not_to equal compiled
    end

    it "is dropped by FactoryBot.reload" do
      define_class("User")
      factory = register_factory(:user)
      compiled = compiled_factory(factory)

      FactoryBot.reload

      expect(compiled_factory(factory)).not_to equal compiled
    end
  end

  describe "precedence" do
    before do
      define_class("User") { attr_accessor :name, :admin, :great }
    end

    it "lists the parent's attributes before the factory's own" do
      register_factory(:user) { name { "John" } }
      child = register_factory(:admin, parent: :user) { admin { true } }

      expect(compiled_factory(child).attributes.names).to eq [:name, :admin]
    end

    it "prefers runtime traits over base traits and the definition" do
      register_factory(:user) do
        name { "John" }
        trait(:male) { name { "Joe" } }
        trait(:female) { name { "Jane" } }
      end
      male_user = register_factory(:male_user, parent: :user, traits: [:male])

      expect(compiled_factory(male_user).run(:build, {}).name).to eq "Joe"
      expect(compiled_factory(male_user, [:female]).run(:build, {}).name).to eq "Jane"
    end

    it "resolves trait names in the scope of the factory being built" do
      register_factory(:user) do
        trait(:great) { great { "GREAT" } }
        trait(:make_it_great) { great }
      end
      greatest_user = register_factory(:greatest_user, parent: :user) do
        trait(:great) { great { "GREATEST" } }
      end
      user = FactoryBot::Internal.factory_by_name(:user)

      expect(compiled_factory(greatest_user, [:make_it_great]).run(:build, {}).great).to eq "GREATEST"
      expect(compiled_factory(user, [:make_it_great]).run(:build, {}).great).to eq "GREAT"
    end

    it "falls back to the global constructor, to_create and callbacks" do
      factory = register_factory(:user)
      compiled = compiled_factory(factory)

      expect(compiled.constructor).to equal FactoryBot::Internal.constructor
      expect(compiled.to_create).to equal FactoryBot::Internal.to_create
      expect(compiled.callbacks).to eq FactoryBot::Internal.callbacks
    end

    it "raises a KeyError naming the factory for an unknown trait" do
      factory = register_factory(:user) do
        trait(:admin) { admin { true } }
      end

      expect { compiled_factory(factory, [:missing]) }.to raise_error(
        KeyError,
        'Trait not registered: "missing". Registered traits: [:admin]. Referenced within "user" definition'
      )
    end
  end
end
