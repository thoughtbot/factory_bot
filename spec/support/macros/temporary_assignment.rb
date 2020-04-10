module TemporaryAssignment
  def with_temporary_assignment(assignee, attribute, temporary_value)
    original_value = assignee.public_send(attribute)
    attribute_setter = "#{attribute}="
    assignee.public_send(attribute_setter, temporary_value)
    yield
  ensure
    assignee.public_send(attribute_setter, original_value)
  end
end

RSpec.configure do |config|
  config.include TemporaryAssignment
end
