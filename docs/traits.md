Both traits & factories both have a `FactoryBot::Definition` (LINK) and hold
on to attributes. (LINK to documentation on how factories work under the
hood).

Defining a trait within another trait is very similar to defining a
trait within a factory.

# Traits

## Defining & registering traits

### Global
In `FactoryBot::Syntax::Default::DSL` (LINK) there is a `trait` method that
builds a `Trait` object and registers it in the global registry.

When it comes time to use the trait, factory_bot will first look to see if
your factory has the trait defined. If it does not, factory_bot will look for
it in the global registry, in `FactoryBot::Definition#trait_by_name` (LINK).

See example in the README here: ANCHOR
### Inline
The role of `FactoryBot::DefinitionProxy` (LINK) is to take the code you
wrote and turn it into factory_bot objects, then store those objects on the
`FactoryBot::Definition` (LINK).

In the case of traits, the `FactoryBot::DefinitionProxy#trait` (LINK) method
builds and registers the `FactoryBot::Trait` (LINK) object.

See example in the README here: ANCHOR
https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#defining-traits
## Compiling & aggregating traits

### Default traits

### Override traits