ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:",
)

class CreateSchema < ActiveRecord::Migration[5.0]
  def self.up
    create_table :categories, force: true do |t|
      t.string :name
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Category < ActiveRecord::Base; end
