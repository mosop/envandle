module Envandle
  class Gem
    def initialize(group, name, args, options)
      @group = group
      @name = name
      @args = args
      @options = options
    end

    def args
      h = @group ? {group: @group} : {}
      h.merge! @options
      if h.empty?
        [@name, *@args]
      else
        [@name, *@args, h]
      end
    end
  end
end
