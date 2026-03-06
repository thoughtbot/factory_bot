---
type: note
created: 2026-02-27T14:38:24-06:00
updated: 2026-02-27T15:38:58-06:00
tags:
  - stub
aliases: []
---
# FactoryBot DSL

## Top-Level DSL Methods

### Inside `FactoryBot.define`

|       Method Name | Description                                                                                         |
| ----------------: | --------------------------------------------------------------------------------------------------- |
|         `factory` | declares a new [[Factories\|Factory]] definition                                                    |
|        `sequence` | declares a new [[Global Sequences\|Global Sequence]]                                                |
|           `trait` | declares a new [[Global Traits\|Global Trait]]                                                      |
|          `before` | declares a new [[Global Callbacks\|Global Callback]] to be invoked *before* an event                |
|           `after` | declares a new  [[Global Callbacks\|Global Callback]] to be invoked *after* an event                |
|        `callback` | declares a new [[Global Callbacks\|Global Callback]] to hook onto an event by name                  |
| `initialize_with` | global customization of object initialization<br>See [[Customize the Initialization of Objects]].   |
|       `to_create` | global customization of object persistence<br>See [[Customize the Persistence of Object Instances]] |
|     `skip_create` | globally disable object persistence<br>See [[Disable the Persistence of Object Instances]]          |

### Inside `FactoryBot.update`

| Method Name | Description                        |
| ----------- | ---------------------------------- |
| `factory`   | reopens a Factory for modification |

## Nested DSL Methods

The DSL below follows the behavior described by the [[Factory Definition Syntax]]. It is made available within any block passed to the `factory` or `trait` DSL methods.

|            Method Name | Description                                                                                                                                                                                                                                                      |
| ---------------------: | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|              `factory` | declares a new [[Child Factories\|Child Factory]] definition                                                                                                                                                                                                     |
|        `add_attribute` | declares a new [[Explicit Attributes\|Explicit Attribute]]                                                                                                                                                                                                       |
|          `association` | declares a new [[Explicit Associations\|Explicit Association]]                                                                                                                                                                                                   |
|            `transient` | starts a new [[Transient Attributes]] block                                                                                                                                                                                                                      |
|             `sequence` | declares a new factory scoped [[Sequences\|Sequence]]                                                                                                                                                                                                            |
|                `trait` | declares a new factory scoped [[Traits\|Trait]]                                                                                                                                                                                                                  |
|      `traits_for_enum` | declares a new [[Enum Traits\|Enum Trait]]                                                                                                                                                                                                                       |
|               `before` | declares a new factory scoped [[Callbacks\|Callback]] to be invoked *before* an event                                                                                                                                                                            |
|                `after` | declares a new factory scoped [[Callbacks\|Callback]] to be invoked *after* an event                                                                                                                                                                             |
|             `callback` | declares a new factory scoped [[Callbacks\|Callback]] to hook onto an event by name                                                                                                                                                                              |
|      `initialize_with` | customizes object initialization for the current factory or trait<br>See [[Customize the Initialization of Objects]].                                                                                                                                            |
|            `to_create` | customizes object persistence for the current factory or trait<br>See [[Customize the Persistence of Object Instances]]                                                                                                                                          |
|          `skip_create` | disables object persistence for the current factory or trait<br>See [[Disable the Persistence of Object Instances]]                                                                                                                                              |
| ✱ *any missing method* | declares a new [[Implicit Attributes\|Implicit Attribute]], declares a new [[Implicit Associations\|Implicit Association]], or activate a [[Trait]]. This relies on Ruby's `method_missing` metaprogramming hook. For more information, see [[Missing Method Shorthand Syntax]]. |
