require 'active_record'

module DefineConstantMacros
  def define_class(path, base = Object, &block)
    namespace, class_name = *constant_path(path)
    klass = Class.new(base)
    namespace.const_set(class_name, klass)
    klass.class_eval(&block) if block_given?
    @defined_constants << path
    klass
  end

  def define_model(name, columns = {}, &block)
    model = define_class(name, ActiveRecord::Base, &block)
    create_table(model.table_name) do |table|
      columns.each do |column_name, type|
        table.column column_name, type
      end
    end
    model
  end

  def create_table(table_name, &block)
    connection = ActiveRecord::Base.connection

    begin
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      connection.create_table(table_name, &block)
      @created_tables << table_name
      connection
    rescue Exception => exception
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      raise exception
    end
  end

  def constant_path(constant_name)
    names = constant_name.split('::')
    class_name = names.pop
    namespace = names.inject(Object) { |result, name| result.const_get(name) }
    [namespace, class_name]
  end

  def default_constants
    @defined_constants ||= []
    @created_tables    ||= []
  end

  def clear_generated_constants
    @defined_constants.reverse.each do |path|
      namespace, class_name = *constant_path(path)
      namespace.send(:remove_const, class_name)
    end

    @defined_constants.clear
  end

  def clear_generated_tables
    @created_tables.each do |table_name|
      ActiveRecord::Base.
        connection.
        execute("DROP TABLE IF EXISTS #{table_name}")
    end
    @created_tables.clear
  end
end

RSpec.configure do |config|
  config.include DefineConstantMacros

  config.before(:all) do
    ActiveRecord::Base.establish_connection(
      adapter:  'sqlite3',
      database: File.join(File.dirname(__FILE__), 'test.db')
    )
  end

  config.before do
    default_constants
  end

  config.after do
    clear_generated_constants
    clear_generated_tables
  end
end
