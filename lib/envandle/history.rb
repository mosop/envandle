module Envandle
  class History
    def receiver
      self
    end

    def argsets
      @argsets ||= []
    end

    def method_missing(name, *args, &block)
      add_argset name, *args, &block
    end

    def add_argset(name, *args, &block)
      a = [name, *args]
      argsets << a
      if block
        h = History.new
        block.call h
        a << h.argsets
      end
    end

    def gem(*args)
      add_argset :gem, *args
    end
  end
end
