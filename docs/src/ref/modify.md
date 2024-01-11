# FactoryBot.modify

The `FactoryBot.modify` class method defines a block with an _overriding_
`factory` method available. That is the only method you can call within the
block.

The `factory` method within this block takes a mandatory factory name, and a
block. All other arguments are ignored. The factory name must already be
defined. The block is a normal [factory definition block](factory.html). Take
note that [hooks](hooks.html) cannot be cleared and continue to compound.

For details on why you'd want to use this, see [the
guide](../modifying-factories/summary.html).
