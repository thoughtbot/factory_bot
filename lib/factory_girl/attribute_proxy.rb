class Factory

  class AttributeProxy

    attr_accessor :factory, :attribute_name, :strategy #:nodoc:

    def initialize (factory, attr, strategy) #:nodoc:
      @factory        = factory
      @attribute_name = attr
      @strategy       = strategy
    end

    # Generates an association using the current build strategy.
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
      Factory.send(strategy, name, attributes)
    end

  end

end
