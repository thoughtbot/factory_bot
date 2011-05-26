module FactoryGirl
  class Proxy #:nodoc:

    attr_reader :callbacks
    attr_writer :ignored_attributes

    def initialize(klass)
    end

    def get(attribute)
      if ignored? attribute
        ignored_attributes[attribute]
      else
        get_attr attribute
      end
    end

    def get_attr(attribute)
    end

    def set(attribute, value)
      if ignored? attribute
        ignored_attributes[attribute] = value
      else
        set_attr attribute, value
      end
    end

    def set_attr(attribute, value)
    end

    def associate(name, factory, attributes)
    end

    def add_callback(name, block)
      @callbacks ||= {}
      @callbacks[name] ||= []
      @callbacks[name] << block
    end

    def run_callbacks(name)
      if @callbacks && @callbacks[name]
        @callbacks[name].each do |block|
          case block.arity
            when 0 then block.call
            when 2 then block.call(@instance, self)
            else
              block.call(@instance)
          end
        end
      end
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
    #   associations are not generated for the attributes_for strategy. Returns
    #   nil in this case.
    #
    # Example:
    #
    #   factory :user do
    #     # ...
    #   end
    #
    #   factory :post do
    #     # ...
    #     author { |post| post.association(:user, :name => 'Joe') }
    #   end
    #
    #   # Builds (but doesn't save) a Post and a User
    #   FactoryGirl.build(:post)
    #
    #   # Builds and saves a User, builds a Post, assigns the User to the
    #   # author association, and saves the User.
    #   FactoryGirl.create(:post)
    #
    def association(name, overrides = {})
      nil
    end

    def method_missing(method, *args, &block)
      get(method)
    end

    def result(to_create)
      raise NotImplementedError, "Strategies must return a result"
    end

    private

    def ignored?(attribute)
      ignored_attributes.has_key? attribute
    end

    def ignored_attributes
      @ignored_attributes ||= {}
    end
  end
end
