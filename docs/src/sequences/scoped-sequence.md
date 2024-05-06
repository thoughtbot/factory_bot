# Scoped sequence

Sequences can be scoped under any attributes with `scoped_sequence` method:

```ruby
FactoryBot.define do
  factory :todo_item do
    scoped_sequence(:priority, :todo_list_id)
  end
end

attributes_for(:todo_item, todo_list_id: 1) # => {:todo_list_id=>1, :priority=>1}
attributes_for(:todo_item, todo_list_id: 1) # => {:todo_list_id=>1, :priority=>2}
attributes_for(:todo_item, todo_list_id: 2) # => {:todo_list_id=>2, :priority=>1}
```
