---
type: note
created: 2025-08-29T16:12:00-05:00
updated: 2025-08-29T16:18:09-05:00
tags:
  - strategies
aliases: []
---
# Build Strategies

Once a `factory_bot` factory is defined, it can be constructed using any of the built-in build strategies, or a [[Custom Build Strategy|custom build strategy]]. 

The built-in strategies are as follows:

- [[build Strategy]]
- [[create Strategy]]
- [[build_stubbed Strategy]]
- [[attributes_for Strategy]]
- [[null Strategy]]

All of these strategies notify on the `factory_bot.run_factory` instrumentation using [ActiveSupport::Notifications](https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html), passing a payload with `:name`, `:strategy`, `:traits`, `:overrides`, and `:factory` keys.

The non-list (`.build`, `.build_pair`, `.create`, etc.) methods take one mandatory argument: the name of the factory. They can then optionally take names of traits, and then a hash of attributes to override. Finally, they can take a block. This block takes the produced object as an argument, and returns an updated object.

The list methods (`.build_list`, `.create_list`, etc.) have two required arguments: the name of the factory, and the number of instances to build. They then can optionally take traits and overrides. Finally, they can take a block. This block takes the produced object and the zero-based index as arguments, and returns an updated object.