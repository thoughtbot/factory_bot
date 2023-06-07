⚠️ **Warning:** You are viewing this file on the `master` branch, which is no
longer used and does not receive any updates. Please view [this file on the
`main` branch](https://github.com/thoughtbot/factory_bot/blob/main/RELEASING.md)
for up-to-date information.

# Releasing

1. Update version file accordingly and run `bundle install` to update the
   Gemfile.lock and `bundle exec appraisal install` to update the Appraisal
   gemfile.lock files.
1. Update `NEWS.md` to reflect the changes since last release.
1. Commit changes.
   There shouldn't be code changes,
   and thus CI doesn't need to run,
   so you can add "[ci skip]" to the commit message.
1. Tag the release: `git tag -s vVERSION`
    - We recommend the [_quick guide on how to sign a release_] from git ready.
1. Push changes: `git push && git push --tags`
1. Build and publish:
    ```bash
    gem build factory_bot.gemspec
    gem push factory_bot-VERSION.gem
    ```
1. Add a new GitHub release using the recent `NEWS.md` as the content. Sample
   URL: https://github.com/thoughtbot/factory_bot/releases/new?tag=vVERSION
1. Announce the new release,
   making sure to say "thank you" to the contributors
   who helped shape this version!
   thoughtbotters can refer to the handbook for announcements guidelines.

[_quick guide on how to sign a release_]: http://gitready.com/advanced/2014/11/02/gpg-sign-releases.html
