module DeclarationMatchers
  def have_static_declaration(name)
    DeclarationMatcher.new(:static).named(name)
  end

  def have_dynamic_declaration(name)
    DeclarationMatcher.new(:dynamic).named(name)
  end

  def have_association_declaration(name)
    DeclarationMatcher.new(:association).named(name)
  end

  def have_implicit_declaration(name)
    DeclarationMatcher.new(:implicit).named(name)
  end

  class DeclarationMatcher
    def initialize(declaration_type)
      @declaration_type = declaration_type
    end

    def matches?(subject)
      subject.declarations.include?(expected_declaration)
    end

    def named(name)
      @name = name
      self
    end

    def ignored
      @ignored = true
      self
    end

    def with_value(value)
      @value = value
      self
    end

    def with_factory(factory)
      @factory = factory
      self
    end

    def with_options(options)
      @options = options
      self
    end

    def failure_message
      [
        "expected declarations to include declaration of type #{@declaration_type}",
        @options ? "with options #{options}" : nil
      ].compact.join ' '
    end

    private

    def expected_declaration
      case @declaration_type
      when :static      then FactoryGirl::Declaration::Static.new(@name, @value, ignored?)
      when :dynamic     then FactoryGirl::Declaration::Dynamic.new(@name, ignored?, @value)
      when :implicit    then FactoryGirl::Declaration::Implicit.new(@name, @factory, ignored?)
      when :association
        if @options
          FactoryGirl::Declaration::Association.new(@name, options)
        else
          FactoryGirl::Declaration::Association.new(@name)
        end
      end
    end

    def ignored?
      !!@ignored
    end

    def options
      @options || {}
    end
  end
end
