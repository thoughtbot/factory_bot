ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), 'test.db')
)

major, minor, _ = ActiveRecord.version.version.split('.').map(&:to_i)
migration_class = (major > 5 || major == 5 && minor >= 1) ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration

class CreateSchema < migration_class
  def self.up
    create_table :categories, :force => true do |t|
      t.string :name
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Category < ActiveRecord::Base; end
