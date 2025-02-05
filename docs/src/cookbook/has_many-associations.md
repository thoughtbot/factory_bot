# has_many associations

There are a few ways to generate data for a `has_many` relationship. The
simplest approach is to write a helper method in plain Ruby to tie together the
different records:

```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "Rachel Sanchez" }
  end
end

def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:post, posts_count, user: user)
  end
end

create(:user).posts.length # 0
user_with_posts.posts.length # 5
user_with_posts(posts_count: 15).posts.length # 15
```

If you prefer to keep the object creation fully within factory\_bot, you can
build the posts in an `after(:create)` callback.


```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "John Doe" }

    # user_with_posts will create post data after the user has been created
    factory :user_with_posts do
      # posts_count is declared as a transient attribute available in the
      # callback via the context
      transient do
        posts_count { 5 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # context, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, context|
        create_list(:post, context.posts_count, user: user)

        # You may need to reload the record here, depending on your application
        user.reload
      end
    end
  end
end

create(:user).posts.length # 0
create(:user_with_posts).posts.length # 5
create(:user_with_posts, posts_count: 15).posts.length # 15
```

A simple example that works for build without having to save to a database:
```ruby
    trait :with_completed_survey_visit do
      after(:build) do |home, evaluator|
        survey_visit = build(:survey_visit, home: home) #belongs_to association
        # Below line is required for the association to work from home.survey_visits without saving to the database
        # Otherwise it only works in one direction: survey_visit.home
        home.survey_visits << survey_visit # has_many association
      end
    end
  end
```

Or, for another solution that works with `build`, `build_stubbed`, and `create`
(although it doesn't work well with `attributes_for`), you can use inline
associations:

```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "Taylor Kim" }

    factory :user_with_posts do
      posts { [association(:post)] }
    end
  end
end

create(:user).posts.length # 0
create(:user_with_posts).posts.length # 1
build(:user_with_posts).posts.length # 1
build_stubbed(:user_with_posts).posts.length # 1
```

For more flexibility you can combine this with the `posts_count` transient
attribute from the callback example:

```ruby
FactoryBot.define do
  factory :post do
    title { "Through the Looking Glass" }
    user
  end

  factory :user do
    name { "Adiza Kumato" }

    factory :user_with_posts do
      transient do
        posts_count { 5 }
      end

      posts do
        Array.new(posts_count) { association(:post) }
      end
    end
  end
end

create(:user_with_posts).posts.length # 5
create(:user_with_posts, posts_count: 15).posts.length # 15
build(:user_with_posts, posts_count: 15).posts.length # 15
build_stubbed(:user_with_posts, posts_count: 15).posts.length # 15
```
