# Releasing

1. Create a release branch using the naming scheme `release-x.x.x`
2. Bump the `VERSION` inside `lib/factory_bot/version.rb`
3. Run `bundle install` to ensure the `Gemfile.lock` file is up to date.
4. Update `NEWS.md` to reflect the changes since last release.
   A useful GitHub URL to compare the changes is:
   <https://github.com/thoughtbot/factory_bot/compare/vLAST_VERSION...main>
5. Commit the changes.
   Note: As there shouldn't be code changes, CI doesn't need to run.
   You can add `[ci skip]` to the commit message to skip it.
6. Tag the release: `git tag -s vVERSION`
    - We recommend the [_quick guide on how to sign a release_] from git ready.
7. Push changes: `git push && git push --tags`
8. Build and publish:

    ```bash
    gem build factory_bot.gemspec
    gem push factory_bot-VERSION.gem
    ```

9. Add a new GitHub release using the recent `NEWS.md` as the content. Sample
   URL: <https://github.com/thoughtbot/factory_bot/releases/new?tag=vVERSION>
10. Announce the new release, making sure to say "thank you" to the contributors who helped shape this version!
   thoughtbotters can refer to the handbook for announcements guidelines.

[_quick guide on how to sign a release_]: http://gitready.com/advanced/2014/11/02/gpg-sign-releases.html
