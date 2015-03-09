# factory_girl [![Build Status](https://secure.travis-ci.org/thoughtbot/factory_girl.png)](http://travis-ci.org/thoughtbot/factory_girl?branch=master) [![Dependency Status](https://gemnasium.com/thoughtbot/factory_girl.png)](https://gemnasium.com/thoughtbot/factory_girl) [![Code Climate](https://img.shields.io/codeclimate/github/thoughtbot/factory_girl.svg)](https://codeclimate.com/github/thoughtbot/factory_girl)

factory_girl is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

If you want to use factory_girl with Rails, see
[factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails).

Documentation
-------------

You should find the documentation for your version of factory_girl on [Rubygems](https://rubygems.org/gems/factory_girl).

See [GETTING_STARTED] for information on defining and using factories.

Install
--------

```shell
gem install factory_girl
```
or add the following line to Gemfile:

```ruby
gem 'factory_girl'
```
and run `bundle install` from your shell.

Supported Ruby versions
-----------------------

The factory_girl 3.x+ series supports MRI Ruby 1.9. Additionally, factory_girl
3.6+ supports JRuby 1.6.7.2+ while running in 1.9 mode. See [GETTING_STARTED]
for more information on configuring the JRuby environment.

For versions of Ruby prior to 1.9, please use factory_girl 2.x.

More Information
----------------

* [Rubygems](https://rubygems.org/gems/factory_girl)
* [Stack Overflow](http://stackoverflow.com/questions/tagged/factory-girl)
* [Issues](https://github.com/thoughtbot/factory_girl/issues)
* [GIANT ROBOTS SMASHING INTO OTHER GIANT ROBOTS](http://robots.thoughtbot.com/)

[GETTING_STARTED]: http://rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md

Contributing
------------

Please see [CONTRIBUTING.md].
Thank you, [contributors]!

[CONTRIBUTING.md]: https://github.com/thoughtbot/factory_girl/blob/master/CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/factory_girl/graphs/contributors

License
-------

factory_girl is Copyright © 2008-2015 thoughtbot. It is free software, and may
be redistributed under the terms specified in the
[LICENSE](https://github.com/thoughtbot/factory_girl/blob/master/LICENSE) file.

About thoughtbot
----------------

![thoughtbot](https://thoughtbot.com/logo.png)

factory_girl is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We are passionate about open source software.
See [our other projects][community].
We are [available for hire][hire].

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com?utm_source=github
