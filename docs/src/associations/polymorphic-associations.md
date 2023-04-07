# Polymorphic associations

Polymorphic associations can be handled with traits:

```ruby
FactoryBot.define do
  factory :video
  factory :photo

  factory :comment do
    for_photo # default to the :for_photo trait if none is specified

    trait :for_video do
      association :commentable, factory: :video
    end

    trait :for_photo do
      association :commentable, factory: :photo
    end
  end
end
```

This allows us to do:

```ruby
create(:comment)
create(:comment, :for_video)
create(:comment, :for_photo)
```
