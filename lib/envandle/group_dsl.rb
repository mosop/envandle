module Envandle
  class GroupDsl
    def initialize(world, name)
      @world = world
      name = name.to_s.strip
      raise "No group name." if name.empty?
      @name = name
    end

    def gem(*args)
      world.gem @name, *args
    end
  end
end
