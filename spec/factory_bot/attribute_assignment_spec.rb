describe "Attribute Assignment" do
  it "sets the <attribute> default value if not overridden" do
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

  it "sets the <attribute> when directly named" do
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
end
