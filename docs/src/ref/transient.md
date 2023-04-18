# transient

Within a `factory` definition block, the goal is to construct an instance of
the class. While factory\_bot does this, it keeps track of data in a
context. To set data on this context, use a `transient` block.

Treat a `transient` block like a `factory` definition block. However, none of
the attributes, associations, traits, or sequences you set will impact the
final object.

This is most useful when paired with [hooks](hooks.html) or
[to_create](build-and-create.html).
