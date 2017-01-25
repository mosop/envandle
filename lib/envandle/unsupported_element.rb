module Envandle
  class UnsupportedElement < NotImplementedError
    def initialize(loc, *)
      super "Unsupported element: #{type} (#{loc})"
      raise self
    end
  end
end
