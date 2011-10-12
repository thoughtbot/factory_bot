class Object
  def maybe_yield
    tap do |_self|
      yield _self if block_given?
    end
  end
end
