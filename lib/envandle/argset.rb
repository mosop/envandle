module Envandle
  class Argset
    def initialize(context, *args, &block)
      @context = context
      @args = args
      h = Envandle.options!(args)
      @options = {}
      h.each do |k, v|
        @options[k.to_s.to_sym] = v
      end
      @block = block
    end

    attr_reader :args, :options, :block

    def dup
      Argset.new(@context, *@args.dup, @options.dup, &@block)
    end

    def clear_reference
      @args = [@args[0]]
      @options.delete :path
      @options.delete :git
      @options.delete :github
      @options.delete :ref
      @options.delete :branch
      @options.delete :tag
    end

    def args_and_options
      @args_and_options ||= begin
        if @options.empty?
          [*@args]
        else
          [*@args, @options]
        end
      end
    end

    def to_s
      a = [@context, *args_and_options]
      a << @block if @block
      a.to_s
    end

    def send_to(o)
      o.__send__ @context, *args_and_options, &@block
    end

    def contextual_groups
      @contextual_groups ||= get_contexutual_groups
    end

    def get_contexutual_groups
      if option = @options[:groups] || @options[:group]
        return option.is_a?(Array) ? option : [option]
      end
      @context.groups_or_default
    end
  end
end
