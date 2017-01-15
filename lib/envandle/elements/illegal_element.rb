module Envandle
  class IllegalElement
    def initialize(loc, *)
      Envandle.legal! loc, type
    end
  end
end
