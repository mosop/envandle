module Envandle
  class PathReference
    extend AsReference

    def initialize(context, group, name, path)
      @context = context
      @group = group
      @name = name
      @path = path
    end

    def spec
      @spec ||= Gemspec.new(Gemspec.find_file(@path, name: @name))
    end

    def to_executable_argset(base)
      args = base.dup
      args.clear_reference
      args.options[:path] = @path
      Argset.new(:gem, *args.args_and_options)
    end
  end
end
