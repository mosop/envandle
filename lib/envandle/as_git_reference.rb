module Envandle
  module AsGitReference
    def self.extended(mod)
      mod.extend AsReference
      mod.class_eval do
        attr_reader :url, :ref
      end
    end
  end
end
