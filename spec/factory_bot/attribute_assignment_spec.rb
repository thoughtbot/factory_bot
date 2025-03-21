describe "Attribute Assignment" do
  it "sets the <attribute> default value if not overriden" do
    name = :user
    define_class("User") { attr_accessor :name, :response }
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    attr_1 = FactoryBot::Declaration::Dynamic.new(:name, false, -> { "orig name" })
    attr_2 = FactoryBot::Declaration::Dynamic.new(:response, false, -> { "orig response" })
    factory.declare_attribute(attr_1)
    factory.declare_attribute(attr_2)

    user = factory.run(FactoryBot::Strategy::Build, {})

    expect(user.name).to eq "orig name"
    expect(user.response).to eq "orig response"
  end

  it "set the <attribute> when directly named" do
    name = :user
    define_class("User") { attr_accessor :name, :response }
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    attr_1 = FactoryBot::Declaration::Dynamic.new(:name, false, -> { "orig name" })
    attr_2 = FactoryBot::Declaration::Dynamic.new(:response, false, -> { "orig response" })
    factory.declare_attribute(attr_1)
    factory.declare_attribute(attr_2)

    user = factory.run(
      FactoryBot::Strategy::Build,
      name: "new name",
      response: "new response"
    )

    expect(user.name).to eq "new name"
    expect(user.response).to eq "new response"
  end

  it "Does not set a default if the attribute's alias is used" do
    name = :user
    define_class("User") { attr_accessor :name, :response_id }
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    attr_1 = FactoryBot::Declaration::Dynamic.new(:name, false, -> { "orig name" })
    attr_2 = FactoryBot::Declaration::Dynamic.new(:response_id, false, -> { 42 })
    factory.declare_attribute(attr_1)
    factory.declare_attribute(attr_2)

    user = factory.run(
      FactoryBot::Strategy::AttributesFor,
      name: "new name",
      response: 13.75
    )

    expect(user[:name]).to eq "new name"
    expect(user[:response]).to eq 13.75
    expect(user[:response_id]).to be_nil
  end

  it "sets both <attribute> and <attribute>_id correctly" do
    name = :user
    define_class("User") { attr_accessor :name, :response, :response_id }
    factory = FactoryBot::Factory.new(name)
    FactoryBot::Internal.register_factory(factory)

    attr_1 = FactoryBot::Declaration::Dynamic.new(:name, false, -> { "orig name" })
    attr_2 = FactoryBot::Declaration::Dynamic.new(:response, false, -> { "orig response" })
    attr_3 = FactoryBot::Declaration::Dynamic.new(:response_id, false, -> { 42 })
    factory.declare_attribute(attr_1)
    factory.declare_attribute(attr_2)
    factory.declare_attribute(attr_3)

    user = factory.run(
      FactoryBot::Strategy::Build,
      name: "new name",
      response: "new response",
      response_id: 13.75
    )

    expect(user.name).to eq "new name"
    expect(user.response).to eq "new response"
    expect(user.response_id).to eq 13.75
  end
end
