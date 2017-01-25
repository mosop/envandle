module Envandle
  def self.arg!(loc, type)
    raise ArgumentError.new("Missing argument: #{type} (#{loc})")
  end
end
