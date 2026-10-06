appraise "7.0" do
  gem "activerecord", "~> 7.0.0"
  gem "activerecord-jdbcsqlite3-adapter", "~> 70.0", platforms: [:jruby]
  gem "sqlite3", "~> 1.4", platforms: [:ruby]
  gem "concurrent-ruby", "< 1.3.5"
end

appraise "7.1" do
  gem "activerecord", "~> 7.1.0"
  gem "activerecord-jdbcsqlite3-adapter", "~> 71.0", platforms: [:jruby]
  gem "sqlite3", "~> 1.4", platforms: [:ruby]
end

appraise "7.2" do
  gem "activerecord", "~> 7.2.0"
  gem "activerecord-jdbcsqlite3-adapter", "~> 72.0", platforms: [:jruby]
  gem "sqlite3", platforms: [:ruby]
end

# activerecord-jdbcsqlite3-adapter has no release for Rails 8.0 or later, so
# the build workflow excludes JRuby from these appraisals.
appraise "8.0" do
  gem "activerecord", "~> 8.0.0"
  remove_gem "activerecord-jdbcsqlite3-adapter"
  gem "sqlite3", platforms: [:ruby]
end

appraise "8.1" do
  gem "activerecord", "~> 8.1.0"
  remove_gem "activerecord-jdbcsqlite3-adapter"
  gem "sqlite3", platforms: [:ruby]
end

appraise "main" do
  gem "activerecord", git: "https://github.com/rails/rails.git", branch: "main"
  remove_gem "activerecord-jdbcsqlite3-adapter"
  gem "sqlite3", platforms: [:ruby]
end
