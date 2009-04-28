require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Factory::Proxy::Stub do
  before do
    @class = "class"
    @instance = "instance"
    stub(@class).new { @instance }
    stub(@instance, :id=)
    stub(@instance).id { 42 }
    stub(@instance).reload { @instance.connection.reload }

    @stub = Factory::Proxy::Stub.new(@class)
  end

  it "should not be a new record" do
    @stub.result.should_not be_new_record
  end

  it "should not be able to connect to the database" do
    lambda { @stub.result.reload }.should raise_error(RuntimeError)
  end

  describe "when a user factory exists" do
    before do
      @user = "user"
      stub(Factory).stub(:user, {}) { @user }
    end

    describe "when asked to associate with another factory" do
      before do
        stub(@instance).owner { @user }
        mock(Factory).stub(:user, {}) { @user }
        mock(@stub).set(:owner, @user)

        @stub.associate(:owner, :user, {})
      end

      it "should set a value for the association" do
        @stub.result.owner.should == @user
      end
    end

    it "should return the association when building one" do
      mock(Factory).create.never
      @stub.association(:user).should == @user
    end

    it "should return the actual instance when asked for the result" do
      @stub.result.should == @instance
    end
  end

  describe "with an existing attribute" do
    before do
      @value = "value"
      mock(@instance).send(:attribute) { @value }
      mock(@instance).send(:attribute=, @value)
      @stub.set(:attribute, @value)
    end

    it "should to the resulting object" do
      @stub.attribute.should == 'value'
    end

    it "should return that value when asked for that attribute" do
      @stub.get(:attribute).should == @value
    end
  end
end
