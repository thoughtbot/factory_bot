---
type: note
created: 2025-11-08T19:32:30-06:00
updated: 2025-11-08T19:34:36-06:00
tags: []
aliases:
  - Implicit Association
---
# Implicit Associations

**Implicit Associations** are declared by invoking an [[Unknown Methods|Unknown Method]] where the association name is used as the method name 

If the factory name is the same as the association name, the factory name can be left out.

```ruby
factory :post do
  # ...
  author
end
```
