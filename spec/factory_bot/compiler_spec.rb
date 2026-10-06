describe FactoryBot::Compiler do
  def compile(factory, *trait_names)
    described_class.new(factory, trait_names).compile
  end

  it "resolves a bare word to an association when a factory is registered" do
    define_class("Post")
    FactoryBot::Internal.register_factory(FactoryBot::Factory.new(:author))
    factory = FactoryBot::Factory.new(:post)
    factory.declare_attribute(FactoryBot::Declaration::Implicit.new(:author, factory.definition))

    attribute = compile(factory).attributes[:author]

    expect(attribute).to be_association
    expect(attribute.factory).to eq :author
  end

  it "resolves a bare word to a sequence attribute when a sequence is registered" do
    define_class("Post")
    FactoryBot::Internal.register_sequence(FactoryBot::Sequence.new(:title))
    factory = FactoryBot::Factory.new(:post)
    factory.declare_attribute(FactoryBot::Declaration::Implicit.new(:title, factory.definition))

    expect(compile(factory).attributes[:title]).to be_a(FactoryBot::Attribute::Sequence)
  end

  it "resolves a bare word to a trait of the factory being built" do
    define_class("Post")
    factory = FactoryBot::Factory.new(:post)
    factory.define_trait(FactoryBot::Trait.new(:published) { title { "published" } })
    factory.declare_attribute(FactoryBot::Declaration::Implicit.new(:published, factory.definition))

    expect(compile(factory).attributes.keys).to eq [:title]
  end

  it "applies requested traits after the factory's own attributes" do
    define_class("Post")
    factory = FactoryBot::Factory.new(:post)
    factory.define_trait(FactoryBot::Trait.new(:published) { title { "published" } })
    factory.declare_attribute(FactoryBot::Declaration::Dynamic.new(:title, false, -> { "draft" }))
    factory.declare_attribute(FactoryBot::Declaration::Dynamic.new(:body, false, -> { "body" }))

    compiled = compile(factory, :published)

    expect(compiled.attributes.keys).to eq [:title, :body]
    expect(FactoryBot::Evaluator.new(compiled, :build).title).to eq "published"
  end

  it "lists the trait names in scope without global traits" do
    define_class("Post")
    FactoryBot::Internal.register_trait(FactoryBot::Trait.new(:global))
    parent = FactoryBot::Internal.register_factory(FactoryBot::Factory.new(:post))
    parent.define_trait(FactoryBot::Trait.new(:published))
    child = FactoryBot::Factory.new(:child_post, parent: :post)
    child.define_trait(FactoryBot::Trait.new(:draft))

    expect(described_class.new(child).trait_names).to eq ["draft", "published"]
  end
end
