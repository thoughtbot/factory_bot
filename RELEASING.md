# Releasing

1. Create a release branch using the naming scheme `release-x.x.x`

   ```shell
   git checkout main
   git pull
   git checkout -b release-x.x.x
   ```

2. Bump the `VERSION` inside `lib/factory_bot/version.rb`

3. Run `bundle install` to ensure the `Gemfile.lock` file is up to date.

4. Generate release notes using [GitHub's New Release](https://github.com/thoughtbot/factory_bot/releases/new) feature.

   1. Click the tags drop down and select "Create new tag"
   2. Fill in the create new tag modal and select "Create"
      Note: This is a safe step as the tag will not be created unless the release is published
   3. Click the "Generate release notes" button
   4. Copy the generated text from the "What's Changed" section, for use when updating `NEWS.md` in the next step.

5. Update `NEWS.md` to reflect the changes since last release.

   1. Add a heading with the version number and date
   2. Paste the release notes you copied from the previous step
      Note: A useful GitHub URL to compare the changes is:
      `https://github.com/thoughtbot/factory_bot/compare/vLAST_VERSION...main`

6. Commit the changes.
   Note: As there shouldn't be code changes, CI doesn't need to run.
   You can add `[ci skip]` to the commit message to skip it.

7. Create a Pull Request, get it reviewed, and merge it to the `main` branch once approved.

8. Back on your machine, switch to the `main` branch and tag the latest commit with the release version: `git tag -s vVERSION`

    - We recommend the [_quick guide on how to sign a release_] from git ready.

9.  Push your changes: `git push && git push --tags`

10. If you haven't already, add yourself as an owner of the `factory_bot` gem on [rubygems.org](https://rubygems.org/) using [the guide in the thoughtbot handbook](https://github.com/thoughtbot/handbook/blob/main/operations/services/rubygems.md#managing-rubygems)

11. Build and publish the gem:

    ```bash
    gem build factory_bot.gemspec
    gem push factory_bot-VERSION.gem
    ```

12. On GitHub, add a new release using the recent `NEWS.md` as the content. Sample
    URL: `https://github.com/thoughtbot/factory_bot/releases/new?tag=vVERSION`

13. Announce the new release, making sure to say "thank you" to the contributors who helped shape this version!
    thoughtbotters can refer to the handbook for announcements guidelines.

[_quick guide on how to sign a release_]: http://gitready.com/advanced/2014/11/02/gpg-sign-releases.html
