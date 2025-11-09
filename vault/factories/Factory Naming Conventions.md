---
type: note
created: 2025-11-08T18:37:14-06:00
updated: 2025-11-08T18:40:57-06:00
tags: []
aliases: []
---
# Factory Naming Conventions

The factory naming convention is to convert the name of the class from PascalCase into snake_case in all lowercase characters. 

## Examples

- A factory with the name `:mailing_address`, for example, will construct objects that are an instance of the `MailingAddress` class. 
- Given a class `UserRelationship`, the convention is to give the factory the name `:user_relationship`.

## Factory Names Must Be Unique

- Multiple factories cannot be given the same name. Attempts to do so will raise an error.