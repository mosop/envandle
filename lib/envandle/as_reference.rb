module Envandle
  module AsReference
    def self.extended(mod)
      mod.class_eval do
        attr_reader :name
      end
    end
  end
end
