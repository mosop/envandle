module Envandle
  module AsReference
    def self.extended(mod)
      mod.class_eval do
        attr_reader :group, :name

        def key
          @key ||= ::Envandle.reference_key(group, name)
        end
      end
    end
  end
end
