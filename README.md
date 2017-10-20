# factory_bot [![Build Status](https://travis-ci.org/thoughtbot/factory_bot.svg)](http://travis-ci.org/thoughtbot/factory_bot?branch=master) [![Dependency Status](https://gemnasium.com/thoughtbot/factory_bot.svg)](https://gemnasium.com/thoughtbot/factory_bot) [![Code Climate](https://codeclimate.com/github/thoughtbot/factory_bot/badges/gpa.svg)](https://codeclimate.com/github/thoughtbot/factory_bot)

factory_bot is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

If you want to use factory_bot with Rails, see
[factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails).

**A historical note:** factory_bot used to be named factory_girl. An explanation of the name change can be found in the [old factory_girl repository](https://github.com/thoughtbot/factory_girl).

_[Interested in the project name?](NAME.md)._

Documentation
-------------

You should find the documentation for your version of factory_bot on [Rubygems](https://rubygems.org/gems/factory_bot).

See [GETTING_STARTED] for information on defining and using factories. We also
have [a detailed introductory video][], available for free on Upcase.

[a detailed introductory video]: https://upcase.com/videos/factory-girl?utm_source=github&utm_medium=open-source&utm_campaign=factory-girl

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

**Caveat:** As of ActiveSupport 5.0 and above, Ruby 2.2.2+ is required. Because
of Rubygems' dependency resolution when installing gems, you may see an error
similar to:

```
$ gem install factory_bot
ERROR:  Error installing factory_bot:
    activesupport requires Ruby version >= 2.2.2.
```

To bypass this, install a pre-5.0 version of ActiveSupport before installing
manually.

Supported Ruby versions
-----------------------

The factory_bot 3.x+ series supports MRI Ruby 1.9. Additionally, factory_bot
3.6+ supports JRuby 1.6.7.2+ while running in 1.9 mode. See [GETTING_STARTED]
for more information on configuring the JRuby environment.

For versions of Ruby prior to 1.9, please use factory_bot 2.x.

More Information
----------------

* [Rubygems](https://rubygems.org/gems/factory_bot)
* [Stack Overflow](http://stackoverflow.com/questions/tagged/factory-bot)
* [Issues](https://github.com/thoughtbot/factory_bot/issues)
* [GIANT ROBOTS SMASHING INTO OTHER GIANT ROBOTS](http://robots.thoughtbot.com/)

You may also find useful information under the [factory_girl tag on Stack Overflow](http://stackoverflow.com/questions/tagged/factory-girl).

[GETTING_STARTED]: http://rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md

Contributing
------------

Please see [CONTRIBUTING.md](https://github.com/thoughtbot/factory_bot/blob/master/CONTRIBUTING.md).

factory_bot was originally written by Joe Ferris and is now maintained by Josh
Clayton. Many improvements and bugfixes were contributed by the [open source
community](https://github.com/thoughtbot/factory_bot/graphs/contributors).

License
-------

factory_bot is Copyright © 2008-2016 Joe Ferris and thoughtbot. It is free
software, and may be redistributed under the terms specified in the
[LICENSE](/LICENSE) file.

About thoughtbot
----------------

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

factory_bot is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community] or
[hire us][hire] to design, develop, and grow your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com?utm_source=github
