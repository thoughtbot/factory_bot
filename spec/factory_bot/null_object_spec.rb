describe FactoryBot::NullObject do
  it "responds to the given methods" do
    methods_to_respond_to = %w[id age name admin?]
    null_object = FactoryBot::NullObject.new(methods_to_respond_to)

    methods_to_respond_to.each do |method_name|
      expect(null_object.__send__(method_name)).to be_nil
      expect(null_object).to respond_to(method_name)
    end
  end

  it "does not respond to other methods" do
    methods_to_respond_to = %w[id age name admin?]
    methods_to_not_respond_to = %w[email date_of_birth title]
    null_object = FactoryBot::NullObject.new(methods_to_respond_to)

    methods_to_not_respond_to.each do |method_name|
      expect { null_object.__send__(method_name) }.to raise_error(NoMethodError)
      expect(null_object).not_to respond_to(method_name)
    end
  end
end
