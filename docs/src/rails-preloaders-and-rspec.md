# Rails Preloaders and RSpec

When running RSpec with a Rails preloader such as `spring` or `zeus`, it's
possible to encounter an `ActiveRecord::AssociationTypeMismatch` error when
creating a factory with associations, as below:

```ruby
FactoryBot.define do
  factory :united_states, class: "Location" do
    name { 'United States' }
    association :location_group, factory: :north_america
  end

  factory :north_america, class: "LocationGroup" do
    name { 'North America' }
  end
end
```

The error occurs during the run of the test suite:

```
Failure/Error: united_states = create(:united_states)
ActiveRecord::AssociationTypeMismatch:
  LocationGroup(#70251250797320) expected, got LocationGroup(#70251200725840)
```

The two possible solutions are to either run the suite without the preloader,
or to add `FactoryBot.reload` to the RSpec configuration, like so:

```ruby
RSpec.configure do |config|
  config.before(:suite) { FactoryBot.reload }
end
```
