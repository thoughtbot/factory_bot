source "https://rubygems.org"

group :development, :test do
  platforms :jruby do
    gem "activerecord-jdbcsqlite3-adapter", "> 50.0"
  end

  platforms :mri do
    gem "sqlite3"
  end
end

gemspec name: "factory_bot"
