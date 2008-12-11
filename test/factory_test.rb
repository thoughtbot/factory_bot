require(File.join(File.dirname(__FILE__), 'test_helper'))

class FactoryTest < Test::Unit::TestCase

  def self.should_instantiate_class

    should "instantiate the build class" do
      assert_kind_of @class, @instance
    end

    should "assign attributes on the instance" do
      assert_equal @first_name, @instance.first_name
      assert_equal @last_name,  @instance.last_name
    end

    should "override attributes using the passed hash" do
      @value = 'Davis'
      @instance = @factory.build(:first_name => @value)
      assert_equal @value, @instance.first_name
    end

  end

  context "defining a factory" do

    setup do
      @name    = :user
      @factory = mock('factory')
      @factory.stubs(:factory_name).returns(@name)
      @options = { :class => 'magic' }
      Factory.stubs(:new).returns(@factory)
    end

    should "create a new factory using the specified name and options" do
      Factory.expects(:new).with(@name, @options).returns(@factory)
      Factory.define(@name, @options) {|f| }
    end

    should "pass the factory do the block" do
      yielded = nil
      Factory.define(@name) do |y|
        yielded = y
      end
      assert_equal @factory, yielded
    end

    should "add the factory to the list of factories" do
      Factory.define(@name) {|f| }
      assert_equal Factory.factories[@name], 
                   @factory,
                   "Factories: #{Factory.factories.inspect}"
    end

  end
  
  context "a factory" do

    setup do
      @name    = :user
      @class   = User
      @factory = Factory.new(@name)
    end

    should "have a factory name" do
      assert_equal @name, @factory.factory_name
    end

    should "have a build class" do
      assert_equal @class, @factory.build_class
    end

    should "not allow the same attribute to be added twice" do
      assert_raise(Factory::AttributeDefinitionError) do
        2.times { @factory.add_attribute @name }
      end
    end

    context "when adding an attribute with a value parameter" do

      setup do
        @attr  = :name
        @value = 'Elvis lives!'
        @factory.add_attribute(@attr, @value)
      end

      should "include that value in the generated attributes hash" do
        assert_equal @value, @factory.attributes_for[@attr]
      end

    end

    context "when adding an attribute with a block" do

      setup do
        @attr  = :name
        @attrs = {}
        @proxy = mock('attr-proxy')
        Factory::AttributeProxy.stubs(:new).returns(@proxy)
      end

      should "not evaluate the block when the attribute is added" do
        @factory.add_attribute(@attr) { flunk }
      end

      should "evaluate the block when attributes are generated" do
        called = false
        @factory.add_attribute(@attr) do
          called = true
        end
        @factory.attributes_for
        assert called
      end

      should "use the result of the block as the value of the attribute" do
        value = "Watch out for snakes!"
        @factory.add_attribute(@attr) { value }
        assert_equal value, @factory.attributes_for[@attr]
      end

      should "build an attribute proxy" do
        Factory::AttributeProxy.expects(:new).with(@factory, @attr, :attributes_for, @attrs)
        @factory.add_attribute(@attr) {}
        @factory.attributes_for
      end

      should "yield an attribute proxy to the block" do
        yielded = nil
        @factory.add_attribute(@attr) {|y| yielded = y }
        @factory.attributes_for
        assert_equal @proxy, yielded
      end

      context "when other attributes have previously been defined" do
        
        setup do
          @attr  = :unimportant
          @attrs = {
            :one     => 'whatever',
            :another => 'soup'
          }
          @factory.add_attribute(:one, 'whatever')
          @factory.add_attribute(:another) { 'soup' }
          @factory.add_attribute(@attr) {}
        end

        should "provide previously set attributes" do
          Factory::AttributeProxy.expects(:new).with(@factory, @attr, :attributes_for, @attrs)
          @factory.attributes_for
        end

      end

    end

    context "when adding an association without a factory name" do

      setup do
        @factory = Factory.new(:post)
        @name    = :user
        @factory.association(@name)
        Post.any_instance.stubs(:user=)
        Factory.stubs(:create)
      end

      should "add an attribute with the name of the association" do
        assert @factory.attributes_for.key?(@name)
      end

      should "create a block that builds the association" do
        Factory.expects(:create).with(@name, {})
        @factory.build
      end

    end

    context "when adding an association with a factory name" do

      setup do
        @factory      = Factory.new(:post)
        @name         = :author
        @factory_name = :user
        @factory.association(@name, :factory => @factory_name)
        Factory.stubs(:create)
      end

      should "add an attribute with the name of the association" do
        assert @factory.attributes_for.key?(@name)
      end

      should "create a block that builds the association" do
        Factory.expects(:create).with(@factory_name, {})
        @factory.build
      end

    end

    should "add an attribute using the method name when passed an undefined method" do
      @attr  = :first_name
      @value = 'Sugar'
      @factory.send(@attr, @value)
      assert_equal @value, @factory.attributes_for[@attr]
    end

    should "allow attributes to be added with strings as names" do
      @factory.add_attribute('name', 'value')
      assert_equal 'value', @factory.attributes_for[:name]
    end

    context "when overriding generated attributes with a hash" do

      setup do
        @attr  = :name
        @value = 'The price is right!'
        @hash  = { @attr => @value }
      end

      should "return the overridden value in the generated attributes" do
        @factory.add_attribute(@attr, 'The price is wrong, Bob!')
        assert_equal @value, @factory.attributes_for(@hash)[@attr]
      end

      should "not call a lazy attribute block for an overridden attribute" do
        @factory.add_attribute(@attr) { flunk }
        @factory.attributes_for(@hash)
      end

      should "override a symbol parameter with a string parameter" do
        @factory.add_attribute(@attr, 'The price is wrong, Bob!')
        @hash = { @attr.to_s => @value }
        assert_equal @value, @factory.attributes_for(@hash)[@attr]
      end

    end

    context "overriding an attribute with an alias" do

      setup do
        @factory.add_attribute(:test, 'original')
        Factory.alias(/(.*)_alias/, '\1')
        @result = @factory.attributes_for(:test_alias => 'new')
      end

      should "use the passed in value for the alias" do
        assert_equal 'new', @result[:test_alias]
      end

      should "discard the predefined value for the attribute" do
        assert_nil @result[:test]
      end

    end

    should "guess the build class from the factory name" do
      assert_equal User, @factory.build_class
    end

    context "when defined with a custom class" do

      setup do
        @class   = User
        @factory = Factory.new(:author, :class => @class)
      end

      should "use the specified class as the build class" do
        assert_equal @class, @factory.build_class
      end

    end

    context "when defined with a class instead of a name" do

      setup do
        @class   = ArgumentError
        @name    = :argument_error
        @factory = Factory.new(@class)
      end

      should "guess the name from the class" do
        assert_equal @name, @factory.factory_name
      end

      should "use the class as the build class" do
        assert_equal @class, @factory.build_class
      end

    end
    context "when defined with a custom class name" do

      setup do
        @class   = ArgumentError
        @factory = Factory.new(:author, :class => :argument_error)
      end

      should "use the specified class as the build class" do
        assert_equal @class, @factory.build_class
      end

    end

    context "with some attributes added" do

      setup do
        @first_name = 'Billy'
        @last_name  = 'Idol'
        @email      = 'test@something.com'

        @factory.add_attribute(:first_name, @first_name)
        @factory.add_attribute(:last_name,  @last_name)
        @factory.add_attribute(:email,      @email)
      end

      context "when building an instance" do

        setup do
          @instance = @factory.build
        end

        should_instantiate_class

        should "not save the instance" do
          assert @instance.new_record?
        end

      end
      
      context "when creating an instance" do

        setup do
          @instance = @factory.create
        end

        should_instantiate_class

        should "save the instance" do
          assert !@instance.new_record?
        end

      end

      should "raise an error for invalid instances" do
        assert_raise(ActiveRecord::RecordInvalid) do
          @factory.create(:first_name => nil)
        end
      end

    end

  end
  
  context "a factory with a name ending in s" do
    
    setup do
      @name    = :business
      @class   = Business
      @factory = Factory.new(@name)
    end
    
    should "have a factory name" do
      assert_equal @name, @factory.factory_name
    end

    should "have a build class" do
      assert_equal @class, @factory.build_class
    end
    
  end

  context "a factory with a string for a name" do

    setup do
      @name    = :user
      @factory = Factory.new(@name.to_s) {}
    end

    should "convert the string to a symbol" do
      assert_equal @name, @factory.factory_name
    end

  end

  context "a factory defined with a string name" do

    setup do
      Factory.factories = {}
      @name    = :user
      @factory = Factory.define(@name.to_s) {}
    end

    should "store the factory using a symbol" do
      assert_equal @factory, Factory.factories[@name]
    end

  end

  context "Factory class" do

    setup do
      @name       = :user
      @attrs      = { :last_name => 'Override' }
      @first_name = 'Johnny'
      @last_name  = 'Winter'
      @class      = User

      Factory.define(@name) do |u|
        u.first_name @first_name
        u.last_name  { @last_name }
        u.email      'jwinter@guitar.org'
      end

      @factory = Factory.factories[@name]
    end

    [:build, :create, :attributes_for].each do |method|

      should "delegate the #{method} method to the factory instance" do
        @factory.expects(method).with(@attrs)
        Factory.send(method, @name, @attrs)
      end

      should "raise an ArgumentError when #{method} is called with a nonexistant factory" do
        assert_raise(ArgumentError) { Factory.send(method, :bogus) }
      end

      should "recognize either 'name' or :name for Factory.#{method}" do
        assert_nothing_raised { Factory.send(method, @name.to_s) }
        assert_nothing_raised { Factory.send(method, @name.to_sym) }
      end

    end

    should "call the create method from the top-level Factory() method" do
      @factory.expects(:create).with(@attrs)
      Factory(@name, @attrs)
    end

  end
  
  def self.context_in_directory_with_files(*files)
    context "in a directory with #{files.to_sentence}" do
      setup do
        @pwd = Dir.pwd
        @tmp_dir = File.join(File.dirname(__FILE__), 'tmp')
        FileUtils.mkdir_p @tmp_dir
        Dir.chdir(@tmp_dir)
        
        files.each do |file|
          FileUtils.mkdir_p File.dirname(file)
          FileUtils.touch file
          Factory.stubs(:require).with(file)
        end
      end
      
      teardown do
        Dir.chdir(@pwd)
        FileUtils.rm_rf(@tmp_dir)
      end

      yield
    end
  end
  
  def self.should_require_definitions_from(file)
    should "load definitions from #{file}" do
      Factory.expects(:require).with(file)
      Factory.find_definitions
    end    
  end
  
  context_in_directory_with_files 'factories.rb' do
    should_require_definitions_from 'factories.rb'
  end
  
  %w(spec test).each do |dir|
    context_in_directory_with_files File.join(dir, 'factories.rb') do
      should_require_definitions_from "#{dir}/factories.rb"
    end

    context_in_directory_with_files File.join(dir, 'factories', 'post_factory.rb') do
      should_require_definitions_from "#{dir}/factories/post_factory.rb"
    end

    context_in_directory_with_files File.join(dir, 'factories', 'post_factory.rb'), File.join(dir, 'factories', 'person_factory.rb') do
      should_require_definitions_from "#{dir}/factories/post_factory.rb"
      should_require_definitions_from "#{dir}/factories/person_factory.rb"
    end

    context_in_directory_with_files File.join(dir, 'factories.rb'), File.join(dir, 'factories', 'post_factory.rb'), File.join(dir, 'factories', 'person_factory.rb') do
      should_require_definitions_from "#{dir}/factories.rb"
      should_require_definitions_from "#{dir}/factories/post_factory.rb"
      should_require_definitions_from "#{dir}/factories/person_factory.rb"
    end
  end

end
