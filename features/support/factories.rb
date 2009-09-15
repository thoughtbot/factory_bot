ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => File.join(File.dirname(__FILE__), 'test.db')
)

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :posts, :force => true do |t|
      t.string  :title
      t.string  :body
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Post < ActiveRecord::Base
end

Factory.define :post do |f|
end

require 'factory_girl/step_definitions'
