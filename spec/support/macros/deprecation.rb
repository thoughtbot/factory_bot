require "active_support"

module SilenceDeprecation
  def silence_deprecation(example)
    cached_silenced = ActiveSupport::Deprecation.silenced
    ActiveSupport::Deprecation.silenced = true
    example.run
    ActiveSupport::Deprecation.silenced = cached_silenced
  end
end

RSpec.configure do |config|
  config.include SilenceDeprecation

  config.around :example, silence_deprecation: true do |example|
    silence_deprecation(example)
  end
end
