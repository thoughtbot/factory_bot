# Releasing

1. Create a release branch using the naming scheme `release-x.x.x`
2. Bump the `VERSION` inside `lib/factory_bot/version.rb`
3. Run `bundle install` to ensure the `Gemfile.lock` file is up to date.
4. Update `NEWS.md` to reflect the changes since last release.
   A useful GitHub URL to compare the changes is:
   `https://github.com/thoughtbot/factory_bot/compare/vLAST_VERSION...main`
5. Commit the changes.
   Note: As there shouldn't be code changes, CI doesn't need to run.
   You can add `[ci skip]` to the commit message to skip it.
6. Create a Pull Request, get it reviewed, and merge it to the `main` branch once approved.
7. Back on your machine, switch to the `main` branch and tag the latest commit with the release version: `git tag -s vVERSION`
    - We recommend the [_quick guide on how to sign a release_] from git ready.
8. Push your changes: `git push && git push --tags`
9. If you haven't already, add yourself as an owner of the `factory_bot` gem on [rubygems.org](https://rubygems.org/) using [the guide in the thoughtbot handbook](https://github.com/thoughtbot/handbook/blob/main/operations/services/rubygems.md#managing-rubygems)
10. Build and publish the gem:

    ```bash
    gem build factory_bot.gemspec
    gem push factory_bot-VERSION.gem
    ```

11. On GitHub, add a new release using the recent `NEWS.md` as the content. Sample
    URL: `https://github.com/thoughtbot/factory_bot/releases/new?tag=vVERSION`
12. Announce the new release, making sure to say "thank you" to the contributors who helped shape this version!
    thoughtbotters can refer to the handbook for announcements guidelines.

[_quick guide on how to sign a release_]: http://gitready.com/advanced/2014/11/02/gpg-sign-releases.html
