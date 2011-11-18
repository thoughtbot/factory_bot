# factory_woman [![Build Status](https://secure.travis-ci.org/thoughtbot/factory_woman.png)](http://travis-ci.org/thoughtbot/factory_woman?branch=master)

factory_woman is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.

If you want to use factory_woman with Rails 3, see
[factory_woman_rails](http://github.com/thoughtbot/factory_woman_rails).

Documentation
-------------

You should find the documentation for your version of factory_woman on [Rubygems](http://rubygems.org/gems/factory_woman).

See {file:GETTING_STARTED.md} for information on defining and using factories.

Install
--------

```shell
gem install factory_woman
```
or add the following line to Gemfile:

```ruby
gem 'factory_woman'
```
and run `bundle install` from your shell.

More Information
----------------

* [Rubygems](http://rubygems.org/gems/factory_woman)
* [Mailing list](http://groups.google.com/group/factory_woman)
* [Issues](http://github.com/thoughtbot/factory_woman/issues)
* [GIANT ROBOTS SMASHING INTO OTHER GIANT ROBOTS](http://giantrobots.thoughtbot.com)

Contributing
------------

Please see the [contribution guidelines](http://github.com/thoughtbot/factory_woman/blob/master/CONTRIBUTION_GUIDELINES.md).

Credits
-------

factory_woman was written by Joe Ferris with contributions from several authors, including:

* Alex Sharp
* Eugene Bolshakov
* Jon Yurek
* Josh Nichols
* Josh Owens
* Nate Sutton
* Josh Clayton
* Thomas Walpole

The syntax layers are derived from software written by the following authors:

* Pete Yandell
* Rick Bradley
* Yossef Mendelssohn

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

factory_woman is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community)

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

factory_woman is Copyright © 2008-2011 Joe Ferris and thoughtbot. It is free software, and may be redistributed under the terms specified in the LICENSE file.
