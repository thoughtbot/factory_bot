# Setting the value

When testing or working in the console, being able to set the sequence to a specific value, is incredibly helpful. This can be achieved by passing the [sequence URI](sequence-uris.md) and the new value to `FactoryBot.set_sequence`:

## Global Sequences

Global sequences are set with the sequence name and the new value:

```ruby
FactoryBot.define do
  sequence(:char, 'a') {|c| "global_character_#{c}" }

  factory :user do
    sequence(:name, %w[Jane Joe Josh Jayde John].to_enum)

    trait :with_email do
      sequence(:email) {|n| "user_#{n}@example.com" }
    end
  end
end

##
# char
generate(:char) # "global_character_a"
FactoryBot.set_sequence(:char, 'z')
generate(:char) # "global_character_z"

##
# user name
generate(:user, :name) # "Jane"
FactoryBot.set_sequence(:user, :name, 'Jayde')
generate(:user, :name) # "Jayde"

##
# user email
generate(:user, :with_email, :email) # "user_1@example.com"
FactoryBot.set_sequence(:user, :with_email, :email, 1_234_567)
generate(:user, :with_email, :email) # "user_1234567@example.com"
```

<div class='warning'>

## Note

- The new value must match the sequence collection: You cannot pass a String to an Integer based sequence!

- An integer based sequence, such as a record ID, can accept any positive integer as the value.

- A fixed collection sequence can accept any value within the collection.

- An unlimited sequence, such as a character `sequence(:unlimited,'a')` will timeout if not found within the default maximum search time of three seconds.

- The timeout can be configured with: `FactoryBot.sequence_setting_timeout = 1.5`

</div>
