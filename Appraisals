appraise "6.1" do
  gem "activerecord", "~> 6.1.0"
  gem "activerecord-jdbcsqlite3-adapter", "~> 61.0", platforms: [:jruby]
  gem "sqlite3", "~> 1.4", platforms: [:ruby]
  gem "concurrent-ruby", "< 1.3.5"
end

appraise "7.0" do
  gem "activerecord", "~> 7.0.0"
  gem "activerecord-jdbcsqlite3-adapter", "~> 70.0", platforms: [:jruby]
  gem "sqlite3", "~> 1.4", platforms: [:ruby]
  gem "concurrent-ruby", "< 1.3.5"
end

appraise "7.1" do
  gem "activerecord", "~> 7.1.0"
  # When version 71 is released, uncomment this and also allow it in the GitHub
  # Action build workflow.
  # gem "activerecord-jdbcsqlite3-adapter", "~> 71.0", platforms: [:jruby]
  gem "sqlite3", "~> 1.4", platforms: [:ruby]
end

appraise "7.2" do
  gem "activerecord", "~> 7.2.0"
  # When version 71 is released, uncomment this and also allow it in the GitHub
  # Action build workflow.
  # gem "activerecord-jdbcsqlite3-adapter", "~> 71.0", platforms: [:jruby]
  gem "sqlite3", platforms: [:ruby]
end

appraise "main" do
  gem "activerecord", git: "https://github.com/rails/rails.git", branch: "main"
  gem "activerecord-jdbcsqlite3-adapter", "~> 70.0", platforms: [:jruby]
  gem "sqlite3", platforms: [:ruby]
end
