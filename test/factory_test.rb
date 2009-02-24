require 'test_helper'

class FactoryTest < Test::Unit::TestCase
factory = Factory.new(:post)
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
    
    should "have a default strategy" do
      assert_equal :create, @factory.default_strategy
    end

    should "not allow the same attribute to be added twice" do
      assert_raise(Factory::AttributeDefinitionError) do
        2.times { @factory.add_attribute :first_name }
      end
    end
    
    should "add a static attribute when an attribute is defined with a value" do
      attribute = mock('attribute', :name => :name)
      Factory::Attribute::Static.
        expects(:new).
        with(:name, 'value').
        returns(attribute)
      @factory.add_attribute(:name, 'value')
    end

    should "add a dynamic attribute when an attribute is defined with a block" do
      attribute = mock('attribute', :name => :name)
      block     = lambda {}
      Factory::Attribute::Dynamic.
        expects(:new).
        with(:name, block).
        returns(attribute)
      @factory.add_attribute(:name, &block)
    end

    should "raise for an attribute with a value and a block" do
      assert_raise(Factory::AttributeDefinitionError) do
        @factory.add_attribute(:name, 'value') {}
      end
    end
    
    context "adding an attribute using a in-line sequence" do
      should 'create the sequence' do
        Factory::Sequence.
          expects(:new)
        @factory.sequence(:name) {}
      end    
      
      should 'add a dynamic attribute' do
        attr = mock('attribute', :name => :name)      
        Factory::Attribute::Dynamic.
          expects(:new).
          with(:name, instance_of(Proc)).
          returns(attr)        
        @factory.sequence(:name) {}
        assert @factory.attributes.include?(attr)
      end
    end    

    context "after adding an attribute" do
      setup do
        @attribute = mock('attribute')
        @proxy     = mock('proxy')

        @attribute.                stubs(:name).  returns(:name)
        @attribute.                stubs(:add_to)
        @proxy.                    stubs(:set)
        @proxy.                    stubs(:result).returns('result')
        Factory::Attribute::Static.stubs(:new).   returns(@attribute)
        Factory::Proxy::Build.     stubs(:new).   returns(@proxy)

        @factory.add_attribute(:name, 'value')
      end

      should "create the right proxy using the build class when running" do
        Factory::Proxy::Build.
          expects(:new).
          with(@factory.build_class).
          returns(@proxy)
        @factory.run(Factory::Proxy::Build, {})
      end

      should "add the attribute to the proxy when running" do
        @attribute.expects(:add_to).with(@proxy)
        @factory.run(Factory::Proxy::Build, {})
      end

      should "return the result from the proxy when running" do
        @proxy.expects(:result).with().returns('result')
        assert_equal 'result',
                     @factory.run(Factory::Proxy::Build, {})
      end
    end

    should "add an association without a factory name or overrides" do
      factory = Factory.new(:post)
      name    = :user
      attr    = 'attribute'
      Factory::Attribute::Association.
        expects(:new).
        with(name, name, {}).
        returns(attr)
      factory.association(name)
      assert factory.attributes.include?(attr)
    end

    should "add an association with overrides" do
      factory   = Factory.new(:post)
      name      = :user
      attr      = 'attribute'
      overrides = { :first_name => 'Ben' }
      Factory::Attribute::Association.
        expects(:new).
        with(name, name, overrides).
        returns(attr)
      factory.association(name, overrides)
      assert factory.attributes.include?(attr)
    end

    should "add an association with a factory name" do
      factory = Factory.new(:post)
      attr = 'attribute'
      Factory::Attribute::Association.
        expects(:new).
        with(:author, :user, {}).
        returns(attr)
      factory.association(:author, :factory => :user)
      assert factory.attributes.include?(attr)
    end

    should "add an association with a factory name and overrides" do
      factory = Factory.new(:post)
      attr = 'attribute'
      Factory::Attribute::Association.
        expects(:new).
        with(:author, :user, :first_name => 'Ben').
        returns(attr)
      factory.association(:author, :factory => :user, :first_name => 'Ben')
      assert factory.attributes.include?(attr)
    end
    
    should "raise for a self referencing association" do
      factory = Factory.new(:post)
      assert_raise(Factory::AssociationDefinitionError) do
        factory.association(:parent, :factory => :post)
      end
    end    

    should "add an attribute using the method name when passed an undefined method" do
      attr  = mock('attribute', :name => :name)
      block = lambda {}
      Factory::Attribute::Static.
        expects(:new).
        with(:name, 'value').
        returns(attr)
      @factory.send(:name, 'value')
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
        result = @factory.run(Factory::Proxy::AttributesFor, @hash)
        assert_equal @value, result[@attr]
      end

      should "not call a lazy attribute block for an overridden attribute" do
        @factory.add_attribute(@attr) { flunk }
        result = @factory.run(Factory::Proxy::AttributesFor, @hash)
      end

      should "override a symbol parameter with a string parameter" do
        @factory.add_attribute(@attr, 'The price is wrong, Bob!')
        @hash = { @attr.to_s => @value }
        result = @factory.run(Factory::Proxy::AttributesFor, @hash)
        assert_equal @value, result[@attr]
      end
    end

    context "overriding an attribute with an alias" do
      setup do
        @factory.add_attribute(:test, 'original')
        Factory.alias(/(.*)_alias/, '\1')
        @result = @factory.run(Factory::Proxy::AttributesFor, 
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
      @name    = :user
      @factory = mock('factory')

      Factory.factories[@name] = @factory
    end

    teardown { Factory.factories.clear }

    should "use Proxy::AttributesFor for Factory.attributes_for" do
      @factory.
        expects(:run).
        with(Factory::Proxy::AttributesFor, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.attributes_for(@name, :attr => 'value')
    end

    should "use Proxy::Build for Factory.build" do
      @factory.
        expects(:run).
        with(Factory::Proxy::Build, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.build(@name, :attr => 'value')
    end

    should "use Proxy::Create for Factory.create" do
      @factory.
        expects(:run).
        with(Factory::Proxy::Create, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.create(@name, :attr => 'value')
    end
    
    should "use Proxy::Stub for Factory.stub" do
      @factory.
        expects(:run).
        with(Factory::Proxy::Stub, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.stub(@name, :attr => 'value')
    end    
    
    should "use default strategy option as Factory.default_strategy" do
      @factory.stubs(:default_strategy).returns(:create)
      @factory.
        expects(:run).
        with(Factory::Proxy::Create, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory.default_strategy(@name, :attr => 'value')
    end    

    should "use the default strategy for the global Factory method" do
      @factory.stubs(:default_strategy).returns(:create)    
      @factory.
        expects(:run).
        with(Factory::Proxy::Create, :attr => 'value').
        returns('result')
      assert_equal 'result', Factory(@name, :attr => 'value')
    end

    [:build, :create, :attributes_for, :stub].each do |method|
      should "raise an ArgumentError on #{method} with a nonexistant factory" do
        assert_raise(ArgumentError) { Factory.send(method, :bogus) }
      end

      should "recognize either 'name' or :name for Factory.#{method}" do
        @factory.stubs(:run)
        assert_nothing_raised { Factory.send(method, @name.to_s) }
        assert_nothing_raised { Factory.send(method, @name.to_sym) }
      end
    end
  end
  
  context 'defining a factory with a parent parameter' do
    setup do
      @parent = Factory.define :object do |f|
        f.name  'Name'
      end
    end
    
    should 'raise an ArgumentError when trying to use a non-existent factory as parent' do
      assert_raise(ArgumentError) { Factory.define(:child, :parent => :nonexsitent) {} }
    end
    
    should 'create a new factory using the class of the parent' do
      child = Factory.define(:child, :parent => :object) {}
      assert_equal @parent.build_class, child.build_class
    end

    should 'create a new factory while overriding the parent class' do
      class Other; end

      child = Factory.define(:child, :parent => :object, :class => Other) {}
      assert_equal Other, child.build_class
    end
    
    should 'create a new factory with attributes of the parent' do
      child = Factory.define(:child, :parent => :object) {}
      assert_equal 1, child.attributes.size
      assert_equal :name, child.attributes.first.name
    end
    
    should 'allow to define additional attributes' do
      child = Factory.define(:child, :parent => :object) do |f|
        f.email 'person@somebody.com'
      end
      assert_equal 2, child.attributes.size
    end
    
    should 'allow to override parent attributes' do
      child = Factory.define(:child, :parent => :object) do |f|
        f.name { 'Child Name' }
      end
      assert_equal 1, child.attributes.size
      assert_kind_of Factory::Attribute::Dynamic, child.attributes.first
    end
  end
  
  context 'defining a factory with a default strategy parameter' do
    should 'raise an ArgumentError when trying to use a non-existent factory' do
      assert_raise(ArgumentError) { Factory.define(:object, :default_strategy => :nonexistent) {} }
    end
    
    should 'create a new factory with a specified default strategy' do
      factory = Factory.define(:object, :default_strategy => :stub) {}
      assert_equal :stub, factory.default_strategy
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
