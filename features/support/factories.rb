ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(File.dirname(__FILE__), 'test.db'),
)

migration_class =
  if ActiveRecord::Migration.respond_to?(:[])
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class CreateSchema < migration_class
  def self.up
    create_table :categories, force: true do |t|
      t.string :name
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Category < ActiveRecord::Base; end
