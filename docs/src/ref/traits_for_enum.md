# traits_for_enum

With a `factory` definition block, the `traits_for_enum` method is a helper for
any object with an attribute that can be one of a few values. The original
inspiration was [`ActiveRecord::Enum`] but it can apply to any attribute with a
restricted set of values.

[`ActiveRecord::Enum`]: https://api.rubyonrails.org/classes/ActiveRecord/Enum.html

This method creates a trait for each value.

The `traits_for_enum` method takes a required attribute name and an optional
set of values. The values can be any Enumerable, such as Array or Hash. By
default, the values are `nil`.

If the values are an Array, this method defines a trait for each element in the
array. The trait's name is the array element, and it sets the attribute to the
same array element.

If the values are a Hash, this method defines traits based on the keys,
setting the attribute to the values. The trait's name is the key, and it sets
the attribute to the value.

If the value is any other Enumerable, it treats it like an Array or Hash based
on whether `#each` iterates in pairs like it does for Hashes.

If the value is nil, it uses a class method named after the pluralized
attribute name.

```ruby
FactoryBot.define do
  factory :article do
    traits_for_enum :visibility, [:public, :private]
    # trait :public do
    #   visibility { :public }
    # end
    # trait :private do
    #   visibility { :private }
    # end

    traits_for_enum :collaborative, draft: 0, shared: 1
    # trait :draft do
    #   collaborative { 0 }
    # end
    # trait :shared do
    #   collaborative { 1 }
    # end

    traits_for_enum :status
    # Article.statuses.each do |key, value|
    #   trait key do
    #     status { value }
    #   end
    # end
  end
end
```
