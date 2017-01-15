module Envandle
  module AsContext
    def self.extended(mod)
      mod.class_eval do
        def gemfile
          @context.gemfile
        end

        def groups_or_default
          a = groups
          a.empty? ? [nil] : a
        end
      end
    end
  end
end
