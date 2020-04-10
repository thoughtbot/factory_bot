# factory_bot [![Build Status][ci-image]][ci] [![Code Climate][grade-image]][grade] [![Gem Version][version-image]][version] [![Reviewed by Hound][hound-badge-image]][hound]

factory_bot is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

If you want to use factory_bot with Rails, see
[factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails).

_[Interested in the history of the project name?][NAME]_


### Transitioning from factory\_girl?

Check out the [guide](https://github.com/thoughtbot/factory_bot/blob/4-9-0-stable/UPGRADE_FROM_FACTORY_GIRL.md).


Documentation
-------------

You should find the documentation for your version of factory_bot on [Rubygems](https://rubygems.org/gems/factory_bot).

See [GETTING_STARTED] for information on defining and using factories. We also
have [a detailed introductory video][], available for free on Upcase.

[a detailed introductory video]: https://upcase.com/videos/factory-bot?utm_source=github&utm_medium=open-source&utm_campaign=factory-girl

Install
--------

Add the following line to Gemfile:

```ruby
gem 'factory_bot'
```

and run `bundle install` from your shell.

To install the gem manually from your shell, run:

```shell
gem install factory_bot
```

Supported Ruby versions
-----------------------

The factory_bot 5.x series supports MRI Ruby 2.3+.

The factory_bot 3.x+ series supports MRI Ruby 1.9. Additionally, factory_bot
3.6+ supports JRuby 1.6.7.2+ while running in 1.9 mode. See [GETTING_STARTED]
for more information on configuring the JRuby environment.

For versions of Ruby prior to 1.9, please use factory_bot 2.x.

More Information
----------------

* [Rubygems](https://rubygems.org/gems/factory_bot)
* [Stack Overflow](https://stackoverflow.com/questions/tagged/factory-bot)
* [Issues](https://github.com/thoughtbot/factory_bot/issues)
* [GIANT ROBOTS SMASHING INTO OTHER GIANT ROBOTS](https://robots.thoughtbot.com/)

[GETTING_STARTED]: https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md
[NAME]: https://github.com/thoughtbot/factory_bot/blob/master/NAME.md

Useful Tools
------------

* [FactoryTrace](https://github.com/djezzzl/factory_trace) - helps to find unused factories and traits.

Contributing
------------

Please see [CONTRIBUTING.md](https://github.com/thoughtbot/factory_bot/blob/master/CONTRIBUTING.md).

factory_bot was originally written by Joe Ferris and is maintained by thoughtbot.
Many improvements and bugfixes were contributed by the [open source
community](https://github.com/thoughtbot/factory_bot/graphs/contributors).

License
-------

factory_bot is Copyright © 2008-2020 Joe Ferris and thoughtbot. It is free
software, and may be redistributed under the terms specified in the
[LICENSE] file.

[LICENSE]: https://github.com/thoughtbot/factory_bot/blob/master/LICENSE


About thoughtbot
----------------

![thoughtbot](https://thoughtbot.com/brand_assets/93:44.svg)

factory_bot is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community] or
[hire us][hire] to design, develop, and grow your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
[ci-image]: https://travis-ci.org/thoughtbot/factory_bot.svg
[ci]: https://travis-ci.org/thoughtbot/factory_bot?branch=master
[grade-image]: https://codeclimate.com/github/thoughtbot/factory_bot/badges/gpa.svg
[grade]: https://codeclimate.com/github/thoughtbot/factory_bot
[version-image]: https://badge.fury.io/rb/factory_bot.svg
[version]: https://badge.fury.io/rb/factory_bot
[hound-badge-image]: https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg
[hound]: https://houndci.com
