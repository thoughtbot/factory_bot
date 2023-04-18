# association

Within a factory block, use the `association` method to always make an
additional object alongside this one. This name best makes sense within the
context of ActiveRecord.

The `association` method takes a mandatory name and optional options.

The options are zero or more trait names (Symbols), followed by a hash
of attribute overrides. When constructing this association, factory\_bot uses
the trait and attribute overrides given.

See [method_missing](method_missing.html) for a shorthand. See [build
strategies](build-strategies.html) for an explanation of how each build
strategy handles associations.
