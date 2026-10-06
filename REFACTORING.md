# Reaching this design from factory_bot 6 by refactoring

This document describes how factory_bot's current codebase could arrive at
the design used in this gem through a sequence of refactorings, each one
shippable on its own, instead of a rewrite.

## Safety net

The `spec/acceptance` files in factory_bot pin user-facing behavior and ran
against this gem with almost no edits. They are the contract for every step
below.

The `spec/factory_bot/**` unit specs are coupled to the classes being removed
(`Declaration`, `DeclarationList`, `AttributeList`, `EvaluatorClassDefiner`,
the decorators, `DefinitionHierarchy`, `CallbacksObserver`). Each step deletes
the unit specs for the classes it removes and relies on the acceptance suite.

## What had the most impact

Ranked by how much of the current complexity each choice removed.

1. **Compile once into an immutable snapshot; never clone.** `Factory#with_traits`,
   `Trait#clone` and `Definition#initialize_copy` run on every call that passes
   traits. The cloning is why three other mechanisms exist: the inline-sequence
   URI registry (`DefinitionProxy#__fetch_or_register_sequence`, because a
   cloned trait re-runs its block and would otherwise create a fresh
   `Sequence`), `CallbacksObserver` (cloned traits create new `Callback`
   objects, so duplicates can only be detected per instance at run time), and
   the `@compiled` flags. With a `CompiledFactory` cached per factory name and
   trait list, those become `Array#uniq` and a Hash.

2. **One `Evaluator` over a Hash of attributes.** `EvaluatorClassDefiner`,
   `class_attribute :attribute_lists`, `Evaluator.define_attribute` (with its
   `undef_method` dance) and the per-override singleton methods exist so that
   Ruby method lookup performs attribute inheritance. A `method_missing` lookup
   in a merged, ordered Hash does the same job without a class per factory. It
   also removes the aliasing bug where `@cached_attributes` is the same Hash as
   `@overrides`, so evaluated attributes leak into the foreign-key logic.

3. **Precedence in one function.** Today the rules are spread across
   `Declaration::Implicit#build` (which mutates the definition through
   `inherit_traits`), `Definition#compile`, `Definition#aggregate_from_traits_and_self`,
   `Factory#compile`, `Factory#inherit_parent_traits`, `DefinitionHierarchy`, and
   `Internal.trait_by_name` (which mutates a global trait's `klass`). In this gem
   they are the first dozen lines of `Compiler`.

4. **Two flags instead of three decorators.** `Decorator::InvocationTracker`,
   `NewConstructor` and `AttributeHash` wrap the evaluator only while
   `initialize_with` runs. A `@constructing` flag, plus recording reads only
   when the evaluation stack is empty, reproduces the same behavior inside the
   evaluator. `AttributeAssigner` shrinks to `Evaluation`.

5. **Enumerator-based sequences.** `Sequence::EnumeratorAdapter`, `Timeout`
   and `UriManager` collapse into `Enumerator.produce`. Sequence URIs are a
   public feature since 6.5.3, so a refactor keeps `generate(:factory, :trait,
   :sequence)` as a lookup index over the simpler `Sequence` rather than dropping
   it as this gem does.

Lower impact, mostly cosmetic: `Data.define` for `Attribute`, `Trait` and
`Callback`; Zeitwerk instead of the require list; folding
`Decorator::DisallowsDuplicatesRegistry` into `Registry` and replacing
`HashWithIndifferentAccess` with a Hash keyed by `to_s`; removing the
`Internal` indirection.

Not refactors at all: the feature cuts made in this gem (`FactoryBot.aliases`
regexes, `use_parent_strategy = false`, the `:null` strategy, Class and
camel-case factory names, `set_sequence`). Each needs a deprecation cycle and a
major version. None of them is structurally required by the steps below; the
`:null` strategy, for example, only disappeared because
`Strategy::AttributesFor#association` can return nil directly.

## Ruby and Rails requirements

factory_bot 6 requires Ruby 3.0 and ActiveSupport 6.1. Steps 1 to 5 need
nothing newer: `def method_missing(name, ...)` with a leading argument is
Ruby 3.0, `Hash#except` is 3.0, `Enumerator.produce` and `filter_map` are 2.7,
and `KeyError.new(receiver:, key:)` is 2.6. Step 6 is the only one with a
constraint: `Data.define` needs Ruby 3.2 (use `Struct.new(keyword_init: true)`
on 3.0 and 3.1, or wait for the floor to move; 3.0 and 3.1 are already past
end of life), and `Zeitwerk::Loader.for_gem` with `warn_on_extra_files:` needs
zeitwerk 2.6, which every ActiveSupport 7 release already depends on.

## Order

Each step leaves the acceptance suite green. Later steps delete more because
earlier ones removed the reasons for the machinery.

### 1. `DefinitionHierarchy` to a plain fold

Replace the anonymous class chain (`Factory#hierarchy_class`,
`DefinitionHierarchy.build_from_definition` and its three `define_method`
calls) with methods on `Factory`:

```ruby
def callbacks   = parent.callbacks + definition.callbacks
def constructor = definition.constructor || parent.constructor
def to_create   = definition.to_create || parent.to_create
```

where the root parent answers with `Internal.callbacks`, `Internal.constructor`
and `Internal.to_create`. Deletes `definition_hierarchy.rb` and half of
`NullFactory`.

### 2. Decorators to evaluator flags

Add `new`, `attributes`, `__construct__` and read tracking to `Evaluator`.
Track a read only when the constructor block is running and no attribute block
is on the evaluation stack; `initialize_with { new(name) }` with
`name { email.gsub(...) }` must still assign `email=` afterwards. `attributes`
reads through the internal path and marks every key as read.

`AttributeAssigner` keeps `object`, `hash` and the alias logic and loses the
decorator wiring. Deletes `decorator.rb`, `decorator/attribute_hash.rb`,
`decorator/invocation_tracker.rb`, `decorator/new_constructor.rb`.

### 3. Cache a compiled snapshot and stop cloning

Introduce `CompiledFactory` (build class, ordered attribute Hash, callbacks,
constructor, to_create, trait scope) computed from the existing `Definition`
and `Trait` objects, cached in the configuration under
`[factory.name, trait_names]`, and cleared by `define`, `modify` and `reload`.
`FactoryRunner#run` asks for the snapshot instead of calling
`factory.with_traits(traits).run`.

Once nothing is cloned:

- `Trait#clone`, `Factory#with_traits`, `Factory#initialize_copy` and
  `Definition#initialize_copy` go.
- Inline sequences are created once at declaration time, so
  `__fetch_or_register_sequence` and the URI-based reuse go. Keep the public URI
  API as an index from URI to `Sequence`.
- `CallbacksObserver` becomes `callbacks.uniq`, because the same `Callback`
  object now reaches a run through every path.
- `FactoryBot.modify` after first use starts working, because the cache is
  cleared instead of the memoized attributes being kept.

This step has the most deletions and the most regression risk, which is why it
follows steps 1 and 2.

### 4. Single evaluator

With the snapshot providing a merged attribute Hash, `EvaluatorClassDefiner`,
`Evaluator.define_attribute`, `class_attribute :attribute_lists` and the override
singleton methods go. `Evaluator#method_missing` looks up the memo, then the
attribute Hash, then the instance, then `SyntaxRunner`.

Attribute names that shadow `Object` methods (`hash`, `display`, `method`,
`format`, `system`) need `Evaluator` to become a `BasicObject` here. Inside the
class, write `::Kernel.raise`, `::FactoryBot::...`, and always declare `&block`.
The one acceptance example that calls `context.instance_values` on the evaluator
changes to `context.instance_eval { @build_strategy }`.

Under `attributes_for`, `NullObject` can be replaced by a hash-mode flag: when
there is no instance and the build class defines the method, answer nil.

### 5. Consolidate resolution into a `Compiler`

Move `Declaration::Implicit#build`, enum expansion and trait scoping out of
`Definition` and `Declaration` into one `Compiler` that:

- resolves bare words to associations, sequence attributes or base-trait
  references without mutating the definition;
- resolves trait names in the scope of the factory being built (own traits,
  then the parent chain, then enum traits, then global), so a parent trait that
  names another trait picks up a child's redefinition without `Trait#clone`;
- stops setting `klass` on global traits;
- raises `AttributeDefinitionError`, `AssociationDefinitionError`,
  `TraitDefinitionError` and the association `ArgumentError` hints from one
  place, with the "referenced within" suffix added to trait `KeyError`s.

Afterwards `Declaration`, `Declaration::*`, `DeclarationList` and
`AttributeList` are deletable; `Definition` becomes plain data.

### 6. Registry, `Internal` and `Configuration`, then cosmetics

Fold `Decorator::DisallowsDuplicatesRegistry` into `Registry` with a
`replace:` flag (strategies allow replacement, the others do not). Key by
`name.to_s` instead of `HashWithIndifferentAccess`; keep the error message
format (`Trait not registered: "queued"`, `Factory not registered: User`) and
construct `KeyError` with `receiver:` and `key:` so did_you_mean keeps working.

Expose `factories`, `sequences`, `traits` and `strategies` on `FactoryBot` and
turn `Internal` into a deprecation shim. `Internal` is marked private but is used
in the wild (factory_bot's own acceptance specs call
`Internal.factory_by_name`), so it needs a deprecation cycle.

Then: `Data.define` for the value objects, Zeitwerk for loading, and the
explicit `require "active_support/core_ext/time/calculations"` that fixes
`build_stubbed` raising without Rails.

## Benchmarks

Measured with benchmark-ips on Ruby 3.4.5, factory_bot 6.6.0 against this gem,
factories defined once per process. Plain is a Ruby class with five dependent
attributes; the ActiveRecord cases use in-memory SQLite.

| Scenario | factory_bot 6.6 | this gem | Speedup |
|---|---|---|---|
| build, plain object, 5 attributes | 108,762 i/s | 225,864 i/s | 2.1x |
| build with 2 runtime traits and an override | 24,032 i/s | 186,624 i/s | 7.8x |
| build a child factory | 67,040 i/s | 130,593 i/s | 1.9x |
| attributes_for, ActiveRecord model | 19,347 i/s | 254,333 i/s | 13x |
| build_stubbed with a trait | 17,485 i/s | 49,205 i/s | 2.8x |
| create post with user association, SQLite | 4,417 i/s | 4,884 i/s | 1.1x |
| build_list of 50 | 2,163 i/s | 4,414 i/s | 2.0x |

| Per call | factory_bot 6.6 | this gem |
|---|---|---|
| build, no traits | 115 objects | 56 objects |
| build, 2 traits | 410 objects | 58 objects |
| classes created by 100 builds with traits | 300 | 0 |

Which step delivers which gain:

- **Step 3 (cached snapshot)** removes the per-call clone, trait re-evaluation,
  recompile and the three new classes whenever runtime traits are passed. That
  is the 7.8x on the trait case, which is 4.5x slower than the plain case in
  factory_bot and the same speed here.
- **Step 4 (single evaluator)** is the baseline 2x on every path: no
  `Class.new`, no `define_method` per attribute, no singleton method per
  override, no `AttributeList` rebuilt and filtered per run. Replacing
  `NullObject`, which is told to respond to `build_class.instance_methods` on
  every `attributes_for` call (thousands of methods on an ActiveRecord model),
  is the 13x.
- **`extend Stubbed`** instead of `instance_eval` with three `def`s and 18
  `define_singleton_method` calls per object is the 2.8x on build_stubbed.
- **Steps 1 and 2** are readability; they do not show up separately.
- `create` is bound by the database, so suites that are mostly `create` will
  not change.

## Internals that change under the acceptance suite's radar

Two behaviors are not pinned by the acceptance specs but may be relied on:

- The `factory_bot.run_factory` payload's `factory:` is a clone whenever traits
  are passed. After step 3 it is the registered `Factory` object.
- `Evaluator` is an `Object` today, so callbacks can call `instance_values`,
  `respond_to?`, `is_a?` on it. After step 4 only `respond_to?`, `inspect` and
  `instance` are guaranteed.

Both are worth a NEWS entry even though they ship as refactors.
