module FactoryGirl
  module TestingHelper
    # compare an object and a hash
    # the keys of the hash must be equal to instance
    # variables of the object
    #
    # @param [Object] object the object which should be compared
    # @param [Hash] hash the equivalent hash
    # @return [TrueClass,FalseClass] the result of the compare
    def are_equal?(object,hash)
      are_equal = true

      begin
        hash.each do |key,value|
          if object.public_send(key.to_sym) != value 
            raise
          end
        end
      rescue
        are_equal = false    
      end

      are_equal
    end
  end
end
