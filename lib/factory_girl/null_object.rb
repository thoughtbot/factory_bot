module FactoryGirl
  class NullObject < ::BasicObject
    def method_missing(*args)
      nil
    end
  end
end
