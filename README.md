# factory_girl [![Build Status](https://travis-ci.org/thoughtbot/factory_girl.svg)](http://travis-ci.org/thoughtbot/factory_girl?branch=master) [![Dependency Status](https://gemnasium.com/thoughtbot/factory_girl.svg)](https://gemnasium.com/thoughtbot/factory_girl) [![Code Climate](https://codeclimate.com/github/thoughtbot/factory_girl/badges/gpa.svg)](https://codeclimate.com/github/thoughtbot/factory_girl)

factory_girl is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

If you want to use factory_girl with Rails, see
[factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails).

_[Interested in the project name?](NAME.md)._

Documentation
-------------

You should find the documentation for your version of factory_girl on [Rubygems](https://rubygems.org/gems/factory_girl).

See [GETTING_STARTED] for information on defining and using factories. We also
have [a detailed introductory video][], available for free on Upcase.

[a detailed introductory video]: https://upcase.com/videos/factory-girl?utm_source=github&utm_medium=open-source&utm_campaign=factory-girl

Install
--------

Add the following line to Gemfile:

```ruby
gem 'factory_girl'
```

and run `bundle install` from your shell.

To install the gem manually from your shell, run:

```shell
gem install factory_girl
```

**Caveat:** As of ActiveSupport 5.0 and above, Ruby 2.2.2+ is required. Because
of Rubygems' dependency resolution when installing gems, you may see an error
similar to:

```
$ gem install factory_girl
ERROR:  Error installing factory_girl:
    activesupport requires Ruby version >= 2.2.2.
```

To bypass this, install a pre-5.0 version of ActiveSupport before installing
manually.

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

Please see [CONTRIBUTING.md](https://github.com/thoughtbot/factory_girl/blob/master/CONTRIBUTING.md).

factory_girl was originally written by Joe Ferris and is now maintained by Josh
Clayton. Many improvements and bugfixes were contributed by the [open source
community](https://github.com/thoughtbot/factory_girl/graphs/contributors).

License
-------

factory_girl is Copyright © 2008-2017 Joe Ferris and thoughtbot. It is free
software, and may be redistributed under the terms specified in the
[LICENSE](/LICENSE) file.

About thoughtbot
----------------

![thoughtbot](http://presskit.thoughtbot.com/images/thoughtbot-logo-for-readmes.svg)

factory_girl is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community] or
[hire us][hire] to design, develop, and grow your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com?utm_source=github
