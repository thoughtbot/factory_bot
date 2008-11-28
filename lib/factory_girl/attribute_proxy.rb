class Factory

  class AttributeProxy

    attr_accessor :factory, :attribute_name, :strategy, :current_values #:nodoc:

    def initialize (factory, attr, strategy, values) #:nodoc:
      @factory        = factory
      @attribute_name = attr
      @strategy       = strategy
      @current_values = values
    end

    # Generates an association using the current build strategy.
    #
    # Arguments:
    #   name: (Symbol)
    #     The name of the factory that should be used to generate this
    #     association.
    #   attributes: (Hash)
    #     A hash of attributes that should be overridden for this association.
    #
    # Returns:
    #   The generated association for the current build strategy. Note that
    #   assocaitions are not generated for the attributes_for strategy. Returns
    #   nil in this case.
    #
    # Example:
    #
    #   Factory.define :user do |f|
    #     # ...
    #   end
    #
    #   Factory.define :post do |f|
    #     # ...
    #     f.author {|a| a.association :user, :name => 'Joe' }
    #   end
    #
    #   # Builds (but doesn't save) a Post and a User
    #   Factory.build(:post)
    #
    #   # Builds and saves a User, builds a Post, assigns the User to the 
    #   # author association, and saves the User.
    #   Factory.create(:post)
    #
    def association (name, attributes = {})
      if strategy == :attributes_for
        nil
      else
        Factory.create(name, attributes)
      end
    end

    # Returns the value for specified attribute. A value will only be available
    # if it was overridden when calling the factory, or if a value is added
    # earlier in the definition of the factory.
    #
    # Arguments:
    #   attribute: (Symbol)
    #     The attribute whose value should be returned.
    #
    # Returns:
    #   The value of the requested attribute. (Object)
    def value_for (attribute)
      unless current_values.key?(attribute)
        raise ArgumentError, "No such attribute: #{attribute.inspect}"
      end
      current_values[attribute]
    end

    # Undefined methods are delegated to value_for, which means that:
    #
    #   Factory.define :user do |f|
    #     f.first_name 'Ben'
    #     f.last_name {|a| a.value_for(:first_name) }
    #   end
    #
    # and:
    #
    #   Factory.define :user do |f|
    #     f.first_name 'Ben'
    #     f.last_name {|a| a.first_name }
    #   end
    #
    # are equivilent.
    def method_missing (name, *args, &block)
      current_values[name]
    end

  end

end
