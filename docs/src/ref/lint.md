# FactoryBot.lint

The `FactoryBot.lint` method tries each factory and raises
`FactoryBot::InvalidFactoryError` on failure.

It can take the following optional arguments:

- A splat of factory names. This will restrict the linting to just the ones listed. The default is all.
- `:strategy` - the [build strategy] to use. The default is `:create`.
- `:traits` - whether to try building each trait, too. The default is `false`.
- `:verbose` - whether to show a stack trace on error. The default is `false`.

[build strategy]: build-strategies.html

Suggested techniques for hooking `.lint` into your system is discussed in [the
guide](../linting-factories/summary.html).
