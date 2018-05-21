describe FactoryBot::Callback do
  it "has a name" do
    expect(FactoryBot::Callback.new(:after_create, -> {}).name).to eq :after_create
  end

  it "converts strings to symbols" do
    expect(FactoryBot::Callback.new("after_create", -> {}).name).to eq :after_create
  end

  it "runs its block with no parameters" do
    ran_with = nil
    FactoryBot::Callback.new(:after_create, -> { ran_with = [] }).run(:one, :two)
    expect(ran_with).to eq []
  end

  it "runs its block with one parameter" do
    ran_with = nil
    FactoryBot::Callback.new(:after_create, ->(one) { ran_with = [one] }).run(:one, :two)
    expect(ran_with).to eq [:one]
  end

  it "runs its block with two parameters" do
    ran_with = nil
    FactoryBot::Callback.new(:after_create, ->(one, two) { ran_with = [one, two] }).run(:one, :two)
    expect(ran_with).to eq [:one, :two]
  end

  it "allows valid callback names to be assigned" do
    FactoryBot.callback_names.each do |callback_name|
      expect { FactoryBot::Callback.new(callback_name, -> {}) }.
        to_not raise_error
    end
  end

  it "raises if an invalid callback name is assigned" do
    expect { FactoryBot::Callback.new(:magic_fairies, -> {}) }.
      to raise_error(FactoryBot::InvalidCallbackNameError, /magic_fairies is not a valid callback name/)
  end
end
