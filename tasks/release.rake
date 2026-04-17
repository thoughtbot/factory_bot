require "date"
require "json"

namespace :release do
  desc "Update NEWS.md with merged PRs since the last release tag. Usage: rake release:update_changelog[VERSION]"
  task :update_changelog, [:version] do |_, args|
    version = args.fetch(:version) { abort "Usage: rake release:update_changelog[VERSION]" }

    # Find the last release tag and when it was made
    last_tag = `git tag --sort=-version:refname`.split.grep(/^v?[0-9]/).first
    since_date = `git log -1 --format=%as #{last_tag}`.strip

    # Collect merged PRs since that date via the GitHub CLI
    raw = `gh pr list --state merged --base main --search "merged:>#{since_date}" --json number,title,author,url --limit 200`
    prs = JSON.parse(raw)
    pr_entries = prs
      .map { |pr| "* #{pr["title"]} by @#{pr.dig("author", "login")} in [##{pr["number"]}](#{pr["url"]})" }
      .join("\n")

    news = File.read("NEWS.md")
    today = Date.today.strftime("%B %-d, %Y")

    # Extract and remove the Unreleased section (if present)
    unreleased = ""
    if news =~ /^## Unreleased\n(.*?)(?=^## )/m
      unreleased = $1.strip
      news = news.sub(/^## Unreleased\n.*?(?=^## )/m, "")
    end

    # Combine unreleased entries and merged PR entries
    body = [unreleased, pr_entries].reject(&:empty?).join("\n")
    new_section = "## #{version} (#{today})\n\n#{body}\n"

    news.sub!(/^(# News\n+)/, "\\1#{new_section}\n")
    File.write("NEWS.md", news)

    puts "Updated NEWS.md for v#{version}"
  end
end
