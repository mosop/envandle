class Location
  def initialize(file, line)
    @file = file
    @line = line
  end

  attr_reader :file, :line

  def to_s
    "#{@file}:#{@line}"
  end
end
