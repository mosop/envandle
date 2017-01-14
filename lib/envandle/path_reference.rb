module Envandle
  class PathReference
    extend AsReference

    def initialize(group, name, path)
      @group = group
      @name = name
      @path = path
    end

    def to_gem(args, options)
      Gem.new(@group, @name, [], {path: @path})
    end

    def spec
      @spec ||= Gemspec.new(Gemspec.find_file(@path, name: @name))
    end
  end
end
