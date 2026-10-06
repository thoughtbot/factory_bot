module FactoryBot
  # What one block declares: a factory body, a trait body, or the global
  # FactoryBot.define block. Plain data; the Compiler gives it meaning.
  class Definition
    attr_reader :name, :declarations, :traits, :callbacks, :enums, :base_trait_names
    attr_accessor :constructor, :to_create

    def initialize(name, base_trait_names: [])
      @name = name
      @declarations = []
      @traits = {}
      @callbacks = []
      @enums = []
      @base_trait_names = base_trait_names.map(&:to_s)
      @constructor = nil
      @to_create = nil
    end

    def declare(declaration, replace: false)
      @declarations.reject! { |existing| existing.name == declaration.name } if replace
      @declarations << declaration
      declaration
    end

    def define_trait(trait, replace: false)
      @traits[trait.name] = trait if replace || !@traits.key?(trait.name)
    end

    def before(*names, &block)
      callback(*names.map { |name| :"before_#{name}" }, &block)
    end

    def after(*names, &block)
      callback(*names.map { |name| :"after_#{name}" }, &block)
    end

    def callback(*names, &block)
      names.each { |name| @callbacks << Callback.new(name: name, block: block) }
    end

    def skip_create
      self.to_create = ->(_instance) {}
    end
  end
end
