class Factory

  class Sequence

    def initialize (&proc)
      @proc  = proc
      @value = 0
    end

    def next
      @value += 1
      @proc.call(@value)
    end

  end

end
