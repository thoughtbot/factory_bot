ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), 'test.db')
)

# Since Rails 5.0 it's not allowed to inherit directly
# from ActiveRecord::Migration
MIGRATION_BASE_CLASS =
  if ActiveRecord::Migration.respond_to?(:[])
    ActiveRecord::Migration[4.2]
  else
    ActiveRecord::Migration
  end

class CreateSchema < MIGRATION_BASE_CLASS
  def self.up
    create_table :categories, :force => true do |t|
      t.string :name
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Category < ActiveRecord::Base; end
