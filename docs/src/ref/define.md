# FactoryBot.define

Each file loaded by factory\_bot is expected to call `FactoryBot.define` with a
block. The block is evaluated within an instance of
`FactoryBot::Syntax::Default::DSL`, giving access to `factory`, `sequence`,
`trait`, and other methods.
