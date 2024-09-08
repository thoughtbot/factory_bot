module StdOutHelpers
  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end

RSpec.configure do |config|
  config.include StdOutHelpers
end
