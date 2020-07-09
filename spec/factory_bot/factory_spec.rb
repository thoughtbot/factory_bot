describe FactoryBot::Factory do
  it "has a factory name" do
    name = :user
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    expect(factory.name).to eq name
  end

  it "has a build class" do
    name = :user
    klass = define_class("User")
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    expect(factory.build_class).to eq klass
  end

  it "returns associations" do
    define_class("Post")
    factory = FactoryBot::Factory.new(:post)
    FactoryBot::Internal.register_factory(FactoryBot::Factory.new(:admin))
    factory.declare_attribute(FactoryBot::Declaration::Association.new(:author, {}))
    factory.declare_attribute(FactoryBot::Declaration::Association.new(:editor, {}))
    factory.declare_attribute(FactoryBot::Declaration::Implicit.new(:admin, factory))
    factory.associations.each do |association|
      expect(association).to be_association
    end
    expect(factory.associations.to_a.length).to eq 3
  end

  it "includes associations from the parent factory" do
    association_on_parent = FactoryBot::Declaration::Association.new(:association_on_parent, {})
    association_on_child = FactoryBot::Declaration::Association.new(:association_on_child, {})

    define_class("Post")
    factory = FactoryBot::Factory.new(:post)
    factory.declare_attribute(association_on_parent)
    FactoryBot::Internal.register_factory(factory)

    child_factory = FactoryBot::Factory.new(:child_post, parent: :post)
    child_factory.declare_attribute(association_on_child)

    expect(child_factory.associations.map(&:name)).to eq [:association_on_parent, :association_on_child]
  end

  describe "when overriding generated attributes with a hash" do
    it "returns the overridden value in the generated attributes" do
      name = :name
      value = "The price is right!"
      hash = {name => value}
      define_class("Name")
      factory = FactoryBot::Factory.new(name)
      declaration =
        FactoryBot::Declaration::Dynamic.new(name, false, -> { flunk })
      factory.declare_attribute(declaration)
      result = factory.run(FactoryBot::Strategy::AttributesFor, hash)
      expect(result[name]).to eq value
    end

    it "overrides a symbol parameter with a string parameter" do
      name = :name
      define_class("Name")
      value = "The price is right!"
      factory = FactoryBot::Factory.new(name)
      FactoryBot::Internal.register_factory(factory)
      declaration =
        FactoryBot::Declaration::Dynamic.new(name, false, -> { flunk })
      factory.declare_attribute(declaration)
      hash = {name.to_s => value}
      result = factory.run(FactoryBot::Strategy::AttributesFor, hash)

      expect(result[name]).to eq value
    end
  end

  describe "overriding an attribute with an alias" do
    it "uses the passed in value for the alias" do
      name = :user
      define_class("User")
      factory = FactoryBot::Factory.new(name)
      FactoryBot::Internal.register_factory(factory)
      attribute = FactoryBot::Declaration::Dynamic.new(
        :test,
        false, -> { "original" }
      )
      factory.declare_attribute(attribute)
      FactoryBot.aliases << [/(.*)_alias/, '\1']
      result = factory.run(
        FactoryBot::Strategy::AttributesFor,
        test_alias: "new"
      )

      expect(result[:test_alias]).to eq "new"
    end

    it "discards the predefined value for the attribute" do
      name = :user
      define_class("User")
      factory = FactoryBot::Factory.new(name)
      FactoryBot::Internal.register_factory(factory)
      attribute = FactoryBot::Declaration::Dynamic.new(
        :test,
        false, -> { "original" }
      )
      factory.declare_attribute(attribute)
      FactoryBot.aliases << [/(.*)_alias/, '\1']
      result = factory.run(
        FactoryBot::Strategy::AttributesFor,
        test_alias: "new"
      )

      expect(result[:test]).to be_nil
    end
  end

  it "guesses the build class from the factory name" do
    name = :user
    define_class("User")
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    expect(factory.build_class).to eq User
  end

  it "creates a new factory using the class of the parent" do
    name = :user
    define_class("User")
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    child = FactoryBot::Factory.new(:child, parent: factory.name)
    child.compile
    expect(child.build_class).to eq factory.build_class
  end

  it "creates a new factory while overriding the parent class" do
    name = :user
    define_class("User")
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    child = FactoryBot::Factory.new(:child, class: String, parent: factory.name)
    child.compile
    expect(child.build_class).to eq String
  end
end

describe FactoryBot::Factory, "when defined with a custom class" do
  it "is an instance of that custom class" do
    factory = FactoryBot::Factory.new(:author, class: Float)
    expect(factory.build_class).to eq Float
  end
end

describe FactoryBot::Factory, "when given a class that overrides #to_s" do
  it "sets build_class correctly" do
    define_class("Overriding")
    define_class("Overriding::Class") do
      def self.to_s
        "Overriding"
      end
    end
    overriding_class = Overriding::Class
    factory = FactoryBot::Factory.new(:overriding_class, class: Overriding::Class)

    expect(factory.build_class).to eq overriding_class
  end
end

describe FactoryBot::Factory, "when defined with a class instead of a name" do
  it "has a name" do
    klass = ArgumentError
    name = :argument_error
    factory = FactoryBot::Factory.new(klass)

    expect(factory.name).to eq name
  end

  it "has a build_class" do
    klass = ArgumentError
    factory = FactoryBot::Factory.new(klass)

    expect(factory.build_class).to eq klass
  end
end

describe FactoryBot::Factory, "when defined with a custom class name" do
  it "has a build_class equal to its custom class name" do
    factory = FactoryBot::Factory.new(:author, class: :argument_error)

    expect(factory.build_class).to eq ArgumentError
  end
end

describe FactoryBot::Factory, "with a name ending in s" do
  it "has a name" do
    factory = FactoryBot::Factory.new(:business)

    expect(factory.name).to eq :business
  end

  it "has a build class" do
    define_class("Business")
    factory = FactoryBot::Factory.new(:business)

    expect(factory.build_class).to eq Business
  end
end

describe FactoryBot::Factory, "with a string for a name" do
  it "has a name" do
    name = :string
    factory = FactoryBot::Factory.new(name.to_s)

    expect(factory.name).to eq name
  end
end

describe FactoryBot::Factory, "for namespaced class" do
  it "sets build_class correctly with a namespaced class with Namespace::Class syntax" do
    name = :settings
    define_class("Admin")
    define_class("Admin::Settings")
    settings_class = Admin::Settings
    factory = FactoryBot::Factory.new(name, class: "Admin::Settings")

    expect(factory.build_class).to eq settings_class
  end

  it "sets build_class correctly with a namespaced class with namespace/class syntax" do
    name = :settings
    define_class("Admin")
    define_class("Admin::Settings")
    settings_class = Admin::Settings
    factory = FactoryBot::Factory.new(name, class: "admin/settings")

    expect(factory.build_class).to eq settings_class
  end
end

describe FactoryBot::Factory, "human names" do
  it "parses names without underscores" do
    factory = FactoryBot::Factory.new(:user)

    expect(factory.names).to eq [:user]
  end

  it "parses human names without underscores" do
    factory = FactoryBot::Factory.new(:user)

    expect(factory.human_names).to eq ["user"]
  end

  it "parses names with underscores" do
    factory = FactoryBot::Factory.new(:happy_user)

    expect(factory.names).to eq [:happy_user]
  end

  it "parses human names with underscores" do
    factory = FactoryBot::Factory.new(:happy_user)

    expect(factory.human_names).to eq ["happy user"]
  end

  it "parses names with big letters" do
    factory = FactoryBot::Factory.new(:LoL)

    expect(factory.names).to eq [:LoL]
  end

  it "parses human names with big letters" do
    factory = FactoryBot::Factory.new(:LoL)

    expect(factory.human_names).to eq ["lol"]
  end

  it "parses names with aliases" do
    factory = FactoryBot::Factory.new(:happy_user, aliases: [:gleeful_user, :person])

    expect(factory.names).to eq [:happy_user, :gleeful_user, :person]
  end

  it "parses human names with aliases" do
    factory = FactoryBot::Factory.new(:happy_user, aliases: [:gleeful_user, :person])

    expect(factory.human_names).to eq ["happy user", "gleeful user", "person"]
  end
end

describe FactoryBot::Factory, "running a factory" do
  def build_factory
    attribute = FactoryBot::Attribute::Dynamic.new(:name, false, -> { "value" })
    attributes = [attribute]
    declaration = FactoryBot::Declaration::Dynamic.new(:name, false, -> { "value" })
    strategy = double("strategy", result: "result", add_observer: true)
    define_model("User", name: :string)
    allow(FactoryBot::Declaration::Dynamic).to receive(:new)
      .and_return declaration
    allow(declaration).to receive(:to_attributes).and_return attributes
    allow(FactoryBot::Strategy::Build).to receive(:new).and_return strategy
    factory = FactoryBot::Factory.new(:user)
    factory.declare_attribute(declaration)
    factory
  end

  it "creates the right strategy using the build class when running" do
    factory = build_factory
    factory.run(FactoryBot::Strategy::Build, {})

    expect(FactoryBot::Strategy::Build).to have_received(:new).once
  end

  it "returns the result from the strategy when running" do
    factory = build_factory

    expect(factory.run(FactoryBot::Strategy::Build, {})).to eq "result"
  end

  it "calls the block and returns the result" do
    factory = build_factory

    block_run = nil
    block = ->(_result) { block_run = "changed" }
    factory.run(FactoryBot::Strategy::Build, {}, &block)
    expect(block_run).to eq "changed"
  end
end
