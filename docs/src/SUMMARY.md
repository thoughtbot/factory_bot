# Summary

[Intro](intro.md)

## Setup

- [Setup](setup.md)
  - [Using Without Bundler](using-without-bundler.md)
  - [Rails Preloaders and RSpec](rails-preloaders-and-rspec.md)

## Getting Started

- [Defining Factories](defining-factories.md)
  - [Specifying the class explicitly](defining/explicit-class.md)
  - [Definition file paths](defining/file-paths.md)
  - [Best practices](defining/best-practices.md)
- [Modifying Factories](modifying-factories.md)
- [Using Factories](using-factories.md)
  - [Build strategies](using-factories/build-strategies.md)
  - [Building or Creating Multiple Records](building-or-creating-multiple-records.md)
  - [Attribute overrides](using-factories/attribute-overrides.md)
- [Linting Factories](linting-factories.md)

## Guides 

- [Attribuutes](attributes.md)
  - [Factory name and attributes](attributes/name-attributes.md)
  - [Hash attributes](attributes/hash-attributes.md)
  - [Dependent Attributes](attributes/dependent-attributes.md)
  - [Transient Attributes](attributes/transient-attributes.md)
    - [With other attributes](attributes/transient-attributes/with-other-attributes.md)
    - [With `attributes_for`](attributes/transient-attributes/with-attributes_for.md)
    - [With callbacks](attributes/transient-attributes/with-callbacks.md)
    - [With associations](attributes/transient-attributes/with-associations.md)
  - [Method Name / Reserved Word Attributes](attributes/method-name-reserved-word-attributes.md)
  - [Static Attributes (deprecated)](attributes/static-attributes.md)
- [Inheritance](inheritance.md)
- [Associations](associations.md)
  - [Implicit definition](associations/implicit-definition.md)
  - [Explicit definition](associations/explicit-definition.md)
  - [Aliases](associations/aliases.md)
  - [Inline definition](associations/inline-definition.md)
  - [Specifying the factory](associations/specifying-the-factory.md)
  - [Overriding attributes](associations/overriding-attributes.md)
  - [Association overrides](associations/association-overrides.md)
  - [Build strategies](associations/build-strategies.md)
- [Sequences](sequences.md)
  - [Global sequences](sequences/global-sequences.md)
  - [With dynamic attributes](sequences/with-dynamic-attributes.md)
  - [As implicit attributes](sequences/as-implicit-attributes.md)
  - [Factory sequences](sequences/factory-sequences.md)
  - [Initial value](sequences/initial-value.md)
  - [Without a block](sequences/without-a-block.md)
  - [Aliases](sequences/aliases.md)
  - [Sequence URIs](sequences/sequence-uris.md)
  - [Rewinding](sequences/rewinding.md)
  - [Setting the value](sequences/setting-the-value.md)
  - [Generating a sequence](sequences/generating.md)
  - [Uniqueness](sequences/uniqueness.md)
- [Traits](traits.md)
  - [As implicit attributes](traits/as-implicit-attributes.md)
  - [Using traits](traits/using.md)
  - [Enum traits](traits/enum.md)
  - [Attribute precedence](traits/attribute-precedence.md)
  - [In child factories](traits/in-child-factories.md)
  - [As mixins](traits/mixins.md)
  - [With associations](traits/with-associations.md)
  - [Traits within traits](traits/traits-within-traits.md)
  - [With transient attributes](traits/with-transient-attributes.md)
- [Callbacks](callbacks.md)
  - [Multiple callbacks](callbacks/multiple-callbacks.md)
  - [Global callbacks](callbacks/global-callbacks.md)
  - [Symbol#to_proc](callbacks/symbol-to_proc.md)
  - [Callback order](callbacks/callback_order.md)
- [ActiveSupport Instrumentation](activesupport-instrumentation.md)

<!-- TODO: disseminate these throughout the sections they belong in? -->
- [Custom Construction](custom-construction.md)
- [Custom Strategies](custom-strategies.md)
- [Custom Callbacks](custom-callbacks.md)
- [Custom Methods to Persist Objects](custom-methods-to-persist-objects.md)

# Reference

<!-- TODO: disseminate these throughout the sections they belong in... -->
<!-- TODO: A lot of this should potentially be part of the YARD documentation -->
<!-- TODO: convert YARD/RDOC to markdown and include here? (single source of truth) -->
- [Build strategies](ref/build-strategies.md)
- [FactoryBot.find_definitions](ref/find_definitions.md)
- [FactoryBot.define](ref/define.md)
- [factory](ref/factory.md)
- [add_attribute](ref/add_attribute.md)
- [association](ref/association.md)
- [sequence](ref/sequence.md)
- [trait](ref/trait.md)
- [method_missing](ref/method_missing.md)
- [traits_for_enum](ref/traits_for_enum.md)
- [skip_create, to_create, and initialize_with](ref/build-and-create.md)
- [transient](ref/transient.md)
- [Hooks](ref/hooks.md)
- [FactoryBot.modify](ref/modify.md)
- [FactoryBot.lint](ref/lint.md)
- [FactoryBot.register_strategy](ref/register_strategy.md)

# Cookbook

- [`has_many` associations](cookbook/has_many-associations.md)
- [`has_and_belongs_to_many` associations](cookbook/has_and_belongs_to_many-associations.md)
- [Polymorphic associations](cookbook/polymorphic-associations.md)
- [Interconnected associations](cookbook/interconnected-associations.md)
