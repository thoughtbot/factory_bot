# Aliases

factory\_bot allows you to define aliases to existing factories to make them
easier to re-use. This could come in handy when, for example, your Post object
has an author attribute that actually refers to an instance of a User class.
While normally factory\_bot can infer the factory name from the association name,
in this case it will look for an author factory in vain. So, alias your user
factory so it can be used under alias names.

```ruby
factory :user, aliases: [:author, :commenter] do
  first_name { "John" }
  last_name { "Doe" }
  date_of_birth { 18.years.ago }
end

factory :post do
  # The alias allows us to write author instead of
  # association :author, factory: :user
  author
  title { "How to read a book effectively" }
  body { "There are five steps involved." }
end

factory :comment do
  # The alias allows us to write commenter instead of
  # association :commenter, factory: :user
  commenter
  body { "Great article!" }
end
```
