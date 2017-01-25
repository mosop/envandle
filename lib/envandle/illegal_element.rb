module Envandle
  class IllegalElement < ArgumentError
    def initialize(loc, *)
      super "Illegal element: #{type} (#{loc})"
      raise self
    end
  end
end
