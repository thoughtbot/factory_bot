require 'spec_helper'

describe "vintage syntax" do
  before do
    define_model('User', :first_name => :string,
                         :last_name  => :string,
                         :email      => :string)

    Factory.sequence(:email) { |n| "somebody#{n}@example.com" }
    Factory.define :user do |factory|
      factory.first_name { 'Bill'               }
      factory.last_name  { 'Nye'                }
      factory.email      { Factory.next(:email) }
    end
  end

  describe "after making an instance" do
    before do
      @instance = Factory(:user, :last_name => 'Rye')
    end

    it "should use attributes from the definition" do
      @instance.first_name.should == 'Bill'
    end

    it "should evaluate attribute blocks for each instance" do
      @instance.email.should =~ /somebody\d+@example.com/
      Factory(:user).email.should_not == @instance.email
    end
  end

  it "raises an ArgumentError when trying to use a non-existent strategy" do
    expect {
      Factory.define(:object, :default_strategy => :nonexistent) {}
    }.to raise_error(ArgumentError)
  end

  it "raises Factory::SequenceAbuseError" do
    Factory.define :sequence_abuser, :class => User do |factory|
      factory.first_name { Factory.sequence(:name) }
    end

    expect {
      Factory(:sequence_abuser)
    }.to raise_error(FactoryGirl::SequenceAbuseError)
  end
end

describe Factory, "referencing a nonexistent factory as a parent" do
  it "raises an ArgumentError when trying to use a non-existent factory as parent" do
    expect {
      Factory.define(:child, :parent => :nonexsitent) {}
      Factory.build(:child)
    }.to raise_error(ArgumentError)
  end
end

describe "defining a factory" do
  before do
    @name    = :user
    @factory = stub("factory", :names => [@name])
    @proxy   = "proxy"
    @options = { :class => 'magic' }
    FactoryGirl::Factory.stubs(:new => @factory)
    FactoryGirl::DefinitionProxy.stubs(:new => @proxy)
  end

  it "creates a new factory using the specified name and options" do
    FactoryGirl::Factory.stubs(:new => @factory)
    Factory.define(@name, @options) {|f| }
    FactoryGirl::Factory.should have_received(:new).with(@name, @options)
  end

  it "passes the factory do the block" do
    yielded = nil
    Factory.define(@name) do |y|
      yielded = y
    end
    yielded.should == @proxy
  end

  it "adds the factory to the list of factories" do
    Factory.define(@name) {|f| }
    @factory.should == FactoryGirl.factory_by_name(@name)
  end
end

describe "after defining a factory" do
  before do
    @name    = :user
    @factory = FactoryGirl::Factory.new(@name)

    FactoryGirl.register_factory(@factory)
  end

  it "uses Proxy::AttributesFor for Factory.attributes_for" do
    @factory.stubs(:run => "result")
    Factory.attributes_for(@name, :attr => 'value').should == 'result'
    @factory.should have_received(:run).with(FactoryGirl::Proxy::AttributesFor, :attr => 'value')
  end

  it "uses Proxy::Build for Factory.build" do
    @factory.stubs(:run => "result")
    Factory.build(@name, :attr => 'value').should == 'result'
    @factory.should have_received(:run).with(FactoryGirl::Proxy::Build, :attr => 'value')
  end

  it "uses Proxy::Create for Factory.create" do
    @factory.stubs(:run => "result")
    Factory.create(@name, :attr => 'value').should == 'result'
    @factory.should have_received(:run).with(FactoryGirl::Proxy::Create, :attr => 'value')
  end

  it "uses Proxy::Stub for Factory.stub" do
    @factory.stubs(:run => "result")
    Factory.stub(@name, :attr => 'value').should == 'result'
    @factory.should have_received(:run).with(FactoryGirl::Proxy::Stub, :attr => 'value')
  end

  it "uses default strategy option as Factory.default_strategy" do
    @factory.stubs(:default_strategy => :create, :run => "result")
    Factory.default_strategy(@name, :attr => 'value').should == 'result'
    @factory.should have_received(:run).with(FactoryGirl::Proxy::Create, :attr => 'value')
  end

  it "uses the default strategy for the global Factory method" do
    @factory.stubs(:default_strategy => :create, :run => "result")
    Factory(@name, :attr => 'value').should == 'result'
    @factory.should have_received(:run).with(FactoryGirl::Proxy::Create, :attr => 'value')
  end

  [:build, :create, :attributes_for, :stub].each do |method|
    it "raises an ArgumentError on #{method} with a nonexistent factory" do
      expect { Factory.send(method, :bogus) }.to raise_error(ArgumentError)
    end

    it "recognizes either 'name' or :name for Factory.#{method}" do
      @factory.stubs(:run)
      lambda { Factory.send(method, @name.to_s) }.should_not raise_error
      lambda { Factory.send(method, @name.to_sym) }.should_not raise_error
    end
  end
end

describe "defining a sequence" do
  before do
    @name = :count
  end

  it "creates a new sequence" do
    Factory.sequence(@name)
    Factory.next(@name).should == 1
  end

  it "uses the supplied block as the sequence generator" do
    Factory.sequence(@name) {|n| "user-#{n}" }
    Factory.next(@name).should == "user-1"
  end

  it "uses the supplied start_value as the sequence start_value" do
    Factory.sequence(@name, "A")
    Factory.next(@name).should == "A"
  end
end

describe "after defining a sequence" do
  before do
    @name     = :test
    @sequence = FactoryGirl::Sequence.new(@name) {}
    @value    = '1 2 5'

    @sequence.stubs(:next => @value)
    FactoryGirl::Sequence.stubs(:new => @sequence)

    Factory.sequence(@name) {}
  end

  it "calls next on the sequence when sent next" do
    Factory.next(@name)
    @sequence.should have_received(:next)
  end

  it "returns the value from the sequence" do
    Factory.next(@name).should == @value
  end
end

describe "an attribute generated by an in-line sequence" do
  before do
    define_model('User', :username => :string)

    Factory.define :user do |factory|
      factory.sequence(:username) { |n| "username#{n}" }
    end

    @username = Factory.attributes_for(:user)[:username]
  end

  it "matches the correct format" do
    @username.should =~ /^username\d+$/
  end

  describe "after the attribute has already been generated once" do
    before do
      @another_username = Factory.attributes_for(:user)[:username]
    end

    it "matches the correct format" do
      @username.should =~ /^username\d+$/
    end

    it "is not the same as the first generated value" do
      @another_username.should_not == @username
    end
  end
end


describe "a factory with a parent" do
  before do
    define_model("User", :username => :string)

    Factory.define(:user) do |factory|
      factory.username "awesome_username"
    end

    Factory.define(:boring_user, :parent => :user) do |factory|
      factory.username "boring_username"
    end
  end

  it "supports defining parents" do
    Factory.build(:boring_user).username.should == "boring_username"
  end
end
