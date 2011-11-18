module Factory
  def self.method_missing(name, *args, &block)
    if FactoryWoman.respond_to?(name)
      $stderr.puts "DEPRECATION WARNING: Change Factory.#{name} to FactoryWoman.#{name}"
      FactoryWoman.send(name, *args, &block)
    else
      super(name, *args, &block)
    end
  end

  def self.const_missing(name)
    if FactoryWoman.const_defined?(name)
      FactoryWoman.const_get(name)
    else
      super(name)
    end
  end
end
