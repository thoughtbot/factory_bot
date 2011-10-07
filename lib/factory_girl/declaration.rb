module FactoryGirl
  class Declaration
    attr_reader :name

    def initialize(name, ignored = false)
      @name    = name
      @ignored = ignored
    end

    def ignore
      $stderr.puts "DEPRECATION WARNING: Use ignore block syntax instead of calling #ignore"
      @ignored = true
    end

    def to_attributes
      build
    end
  end
end
