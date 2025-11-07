---
type: note
created: 2025-08-29T17:43:37-05:00
updated: 2025-08-29T17:47:10-05:00
tags: []
aliases: []
---
# Static Attributes (DEPRECATED)

Static attributes are declared without a block and are no longer available following the release of factory\_bot 5. You can read more about the decision to remove them in [this blog post](https://robots.thoughtbot.com/deprecating-static-attributes-in-factory_bot-4-11).

In the past, a static attribute could be written in the following manner: 

```ruby
factory :robot do
  name "Ralph"
end
```

**The [[Dynamic Attributes]] syntax, however, should be used instead.**
