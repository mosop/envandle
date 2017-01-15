module Envandle
  class UnsupportedElement
    def initialize(loc, *)
      Envandle.support! loc, type
    end
  end
end
