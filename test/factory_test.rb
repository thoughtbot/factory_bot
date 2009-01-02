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
      @instance = @factory.run_strategy(Factory::Strategy::Build,
                                        :first_name => @value)
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

    should "create a new attribute when an attribute is defined" do
      block = lambda {}
      attribute = mock('attribute', :name => :name)
      Factory::Attribute.
        expects(:new).
        with(:name, 'value', block).
        returns(attribute)
      @factory.add_attribute(:name, 'value', &block)
    end

    context "after adding an attribute" do
      setup do
        @attribute = mock('attribute')
        @strategy  = mock('strategy')

        @attribute.              stubs(:name).  returns(:name)
        @attribute.              stubs(:value). returns('value')
        @strategy.               stubs(:set)
        @strategy.               stubs(:result).returns('result')
        Factory::Attribute.      stubs(:new).   returns(@attribute)
        Factory::Strategy::Build.stubs(:new).   returns(@strategy)

        @factory.add_attribute(:name, 'value')
      end

      should "create the right strategy using the build class when running" do
        Factory::Strategy::Build.
          expects(:new).
          with(@factory.build_class).
          returns(@strategy)
        @factory.run_strategy(Factory::Strategy::Build, {})
      end

      should "get the value from the attribute when running" do
        @attribute.expects(:value).with(@strategy).returns('value')
        @factory.run_strategy(Factory::Strategy::Build, {})
      end

      should "set the value on the strategy when running" do
        @strategy.expects(:set).with(:name, 'value')
        @factory.run_strategy(Factory::Strategy::Build, {})
      end

      should "return the result from the strategy when running" do
        @strategy.expects(:result).with().returns('result')
        assert_equal 'result',
                     @factory.run_strategy(Factory::Strategy::Build, {})
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
        result = @factory.run_strategy(Factory::Strategy::AttributesFor, {})
        assert result.key?(@name)
      end

      should "create a block that builds the association" do
        Factory.expects(:create).with(@name, {})
        @factory.run_strategy(Factory::Strategy::Build, {})
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
        result = @factory.run_strategy(Factory::Strategy::AttributesFor, {})
        assert result.key?(@name)
      end

      should "create a block that builds the association" do
        Factory.expects(:create).with(@factory_name, {})
        @factory.run_strategy(Factory::Strategy::Build, {})
      end
    end

    should "add an attribute using the method name when passed an undefined method" do
      attr  = mock('attribute', :name => :name)
      block = lambda {}
      Factory::Attribute.expects(:new).with(:name, 'value', block).returns(attr)
      @factory.send(:name, 'value', &block)
      assert @factory.attributes.include?(attr)
    end

    context "when overriding generated attributes with a hash" do
      setup do
        @attr  = :name
        @value = 'The price is right!'
        @hash  = { @attr => @value }
      end

      should "return the overridden value in the generated attributes" do
        @factory.add_attribute(@attr, 'The price is wrong, Bob!')
        result = @factory.run_strategy(Factory::Strategy::AttributesFor, @hash)
        assert_equal @value, result[@attr]
      end

      should "not call a lazy attribute block for an overridden attribute" do
        @factory.add_attribute(@attr) { flunk }
        result = @factory.run_strategy(Factory::Strategy::AttributesFor, @hash)
      end

      should "override a symbol parameter with a string parameter" do
        @factory.add_attribute(@attr, 'The price is wrong, Bob!')
        @hash = { @attr.to_s => @value }
        result = @factory.run_strategy(Factory::Strategy::AttributesFor, @hash)
        assert_equal @value, result[@attr]
      end
    end

    context "overriding an attribute with an alias" do
      setup do
        @factory.add_attribute(:test, 'original')
        Factory.alias(/(.*)_alias/, '\1')
        @result = @factory.run_strategy(Factory::Strategy::AttributesFor, 
                                        :test_alias => 'new')
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

  context "after defining a factory" do
    setup do
      @name = :user
      Factory.define(@name) do |f|
        f.first_name 'First'
        f.last_name  'Last'
        f.email      'name@example.com'
      end
      @factory = Factory.factories[@name]
    end

    teardown { Factory.factories.clear }

    should "use Strategy::AttributesFor for Factory.attributes_for" do
      @factory.
        expects(:run_strategy).
        with(Factory::Strategy::AttributesFor, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.attributes_for(@name, :attr => 'value')
    end

    should "use Strategy::Build for Factory.build" do
      @factory.
        expects(:run_strategy).
        with(Factory::Strategy::Build, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.build(@name, :attr => 'value')
    end

    should "use Strategy::Create for Factory.create" do
      @factory.
        expects(:run_strategy).
        with(Factory::Strategy::Create, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.create(@name, :attr => 'value')
    end

    should "use Strategy::Create for the global Factory method" do
      @factory.
        expects(:run_strategy).
        with(Factory::Strategy::Create, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory(@name, :attr => 'value')
    end

    [:build, :create, :attributes_for].each do |method|
      should "raise an ArgumentError on #{method} with a nonexistant factory" do
        assert_raise(ArgumentError) { Factory.send(method, :bogus) }
      end

      should "recognize either 'name' or :name for Factory.#{method}" do
        assert_nothing_raised { Factory.send(method, @name.to_s) }
        assert_nothing_raised { Factory.send(method, @name.to_sym) }
      end
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
