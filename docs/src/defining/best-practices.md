# Best practices

It is recommended that you have one factory for each class that provides
the simplest set of attributes necessary to create an instance of that class. If
you're creating ActiveRecord objects, that means that you should only provide
attributes that are required through validations and that do not have defaults.
Other factories can be created through inheritance to cover common scenarios for
each class.

Attempting to define multiple factories with the same name will raise an error.
