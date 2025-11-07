---
type: note
created: 2025-08-29T15:45:11-05:00
updated: 2025-08-29T16:13:27-05:00
tags:
  - strategies
aliases:
  - build_stubbed
---
# `build_stubbed` Strategy

The `FactoryBot.build_stubbed` method returns a fake ActiveRecord object. The
`.build_stubbed_pair` and `.build_stubbed_list` methods are defined similarly
to `.build_pair` and `.build_list`.

It uses `initialize_with` to construct the object, but then stubs methods and
data as appropriate:

- `id` is set sequentially (unless overridden by attributes)
- `created_at` and `updated_at` are set to the current time (unless overridden by attributes)
- all [ActiveModel::Dirty] change tracking is cleared
- `persisted?` is true
- `new_record?` is false
- `destroyed?` is false
- persistence methods raise a `RuntimeError` (`#connection`, `#delete`, `#save`, `#update`, etc.)

After it sets up the object it invokes the `after_stub` hook.

[ActiveModel::Dirty]: https://api.rubyonrails.org/classes/ActiveModel/Dirty.html
## Methods

- `build_stubbed`
- `build_stubbed_pair`
- `build_stubbed_list`
