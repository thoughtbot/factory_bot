RSpec::Matchers.define :be_about_now do
  match do |actual|
    expect(actual).to be_within(2.seconds).of(Time.now)
  end
end
