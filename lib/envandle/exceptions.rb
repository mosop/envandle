module Envandle
  def self.arg!(loc, type)
    raise ArgumentError.new("Missing argument: #{type} (#{loc})")
  end

  def self.legal!(loc, type)
    raise ArgumentError.new("Illegal element: #{type} (#{loc})")
  end

  def self.support!(loc, type)
    raise NotImplementedError.new("Unsupported element: #{type} (#{loc})")
  end
end
