---
type: note
created: 2025-08-29T17:43:37-05:00
updated: 2025-11-08T16:55:22-06:00
tags: []
aliases:
  - Static Attribute
  - Static Attributes
---
# Static Attributes

> [!DANGER] The Static Attribute syntax is defunct
> this is a defunct syntax and is documented here only for historical context

Static attributes were declared without the use of a block and are no longer available following the release of factory\_bot 5. You can read more about the decision to remove them in [this blog post](https://robots.thoughtbot.com/deprecating-static-attributes-in-factory_bot-4-11). 

In the past, a static attribute could be written in the following manner: 

```ruby
factory :robot do
  name "Ralph"
end
```

Today, however, the [[Dynamic Attributes]] syntax should be used.
