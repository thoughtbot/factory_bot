module FactoryBot
  class AssociationDefinitionError < RuntimeError; end

  class AttributeDefinitionError < RuntimeError; end

  class DuplicateDefinitionError < RuntimeError; end

  class InvalidCallbackNameError < RuntimeError; end

  class InvalidFactoryError < RuntimeError; end

  class MethodDefinitionError < RuntimeError; end

  class SequenceAbuseError < RuntimeError; end

  class TraitDefinitionError < RuntimeError; end
end
