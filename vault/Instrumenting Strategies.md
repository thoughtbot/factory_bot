---
type: note
created: 2026-03-06T14:46:58-06:00
updated: 2026-03-06T14:48:35-06:00
tags: []
aliases: []
---
# Instrumenting Strategies

All [[Strategies]] notify on the `factory_bot.run_factory` instrumentation using [ActiveSupport Notifications](https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html), passing a payload with `:name`, `:strategy`, `:traits`, `:overrides`, and `:factory` keys.

see [[ActiveSupport Instrumentation]] for more
