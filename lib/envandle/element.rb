module Envandle
  class Element
    def initialize(loc, context, *args, &block)
      @loc = loc
      @context = context
      @args = Argset.new(self, *args, &block)
    end

    def parse_string_value(v, type)
      if v
        v = v.to_s.strip
        Envandle.arg! @loc, type if v.empty?
        v
      end
    end

    def parse_string_option(name, type)
      parse_string_value(@args.options[name], type)
    end

    def gemfile
      @context.gemfile
    end

    def groups_or_default
      @context.groups_or_default
    end

    def dsl
      self.class::Dsl.new(self)
    end

    def draw(&block)
      block ||= @args.block
      dsl.instance_exec &block if block
    end

    def children
      @children ||= []
    end

    def children_by_type(type = nil)
      if type
        (@children_by_type ||= {})[type] ||= []
      else
        @children_by_type ||= {}
      end
    end

    def <<(child)
      children << child
      children_by_type(child.type) << child
    end

    def send_to_bundler(receiver)
      bundler_argsets.each do |i|
        i.send_to receiver
      end
    end

    def send_to_history(receiver)
      history_argsets.each do |i|
        i.send_to receiver
      end
    end

    def history_argsets
      bundler_argsets
    end
  end
end
