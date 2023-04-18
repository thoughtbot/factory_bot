# factory

Within a `FactoryBot.define` block, you can define factories. Anything defined
using `factory` can be built using a [build strategy](build-strategies.html).

The `factory` method takes three arguments: a required name, an optional hash
of options, and an optional block.

The name is expected to be a Symbol.

## Options

- `:class` - what class to construct. This can be either a class, or a String
  or Symbol (anything that responds to `#to_s`). By default it is either the
  parent's class name or the factory's name.
- `:parent`- the name of another factory that this factory should inherit from.
  Defaults to `nil`.
- `:aliases` - alternative names for this factory. Any of these names can be
  used with a build strategy. Defaults to the empty list.
- `:traits` - base traits that are used by default when building this factory.
  Defaults to the empty list.

## Block

You can use the block to define your factory. Within here you have access to the following methods:

- [`add_attribute`](ref/add_attribute.md)
- [`association`](ref/association.md)
- [`sequence`](ref/sequence.md)
- [`trait`](ref/trait.md)
- [`method_missing`](ref/method_missing.html)
- [`transient`](ref/transient.md)
- [`traits_for_enum`](ref/traits_for_enum.md)
- [`initialize_with`](ref/build-and-create.md)
- [`skip_create`](ref/build-and-create.md)
- [`to_create`](ref/build-and-create.md)
- [`before`](ref/hooks.md)
- [`after`](ref/hooks.md)
- [`callback`](ref/hooks.md)
- `factory`

You can use `factory` inside a `factory` block to define a new factory with an
implied parent.
