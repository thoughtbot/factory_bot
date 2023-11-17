RSpec::Matchers.define :raise_did_you_mean_error do
  supports_block_expectations

  match do |actual|
    # detailed_message introduced in Ruby 3.2 for cleaner integration with
    # did_you_mean. See https://bugs.ruby-lang.org/issues/18564
    matcher = if KeyError.method_defined?(:detailed_message)
      raise_error(
        an_instance_of(KeyError)
        .and(having_attributes(detailed_message: /Did you mean\?/))
      )
    else
      raise_error(KeyError, /Did you mean\?/)
    end

    expect(&actual).to matcher
  end
end
