# Build strategies

Once a factory\_bot factory is defined, it can be constructed using any of the
built-in build strategies, or a custom build strategy.

All of these strategies notify on the `factory_bot.run_factory`
instrumentation using [ActiveSupport::Notifications], passing a payload with
`:name`, `:strategy`, `:traits`, `:overrides`, and `:factory` keys.

[ActiveSupport::Notifications]: https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html

The non-list (`.build`, `.build_pair`, `.create`, etc.) methods take one
mandatory argument: the name of the factory. They can then optionally take
names of traits, and then a hash of attributes to override. Finally, they can
take a block. This block takes the produced object as an argument, and returns
an updated object.

The list methods (`.build_list`, `.create_list`, etc.) have two required
arguments: the name of the factory, and the number of instances to build. They
then can optionally take traits and overrides. Finally, they can take a block.
This block takes the produced object and the zero-based index as arguments, and
returns an updated object.

## `build`

The `FactoryBot.build` method constructs an instance of the class according to
`initialize_with`, which defaults to calling the `.new` class method.
`.build_list` constructs multiple instances, and `.build_pair` is a shorthand
to construct two instances.

After it calls `initialize_with`, it invokes the `after_build` hook.

Associations are constructed using the `build` build strategy.

## `create`

The `FactoryBot.create` method constructs an instance of the class according to
`initialize_with`, and then persists it using `to_create`. The `.create_list`
class method constructs multiple instances, and `.create_pair` is a shorthand
to construct two instances.

After it calls `initialize_with`, it invokes the following hooks in order:

1. `after_build`
1. `before_create`
1. non-hook: `to_create`
1. `after_create`

Associations are constructed using the `create` build strategy.

The `to_create` hook controls how objects are persisted. It takes a block with
the object and the factory\_bot context, and runs it for its side effect. By
default, it calls `#save!`.

## `attributes_for`

The `FactoryBot.attributes_for` method constructs a Hash with the attributes
and their values, using `initialize_with`. The `attributes_for_pair` and
`attributes_for_list` methods work similarly as `build_pair` and `build_list`.

Associations are constructed using the `null` build strategy (they are not built).

No hooks are called.

## `build_stubbed`

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

[ActiveModel::Dirty]: https://api.rubyonrails.org/classes/ActiveModel/Dirty.html

After it sets up the object it invokes the `after_stub` hook.

## `null`

The `FactoryBot.null` method returns `nil`. The `.null_pair` method gives you a
pair of nils, and `.null_list` gives as many nils as you desire. This is used
internally.
