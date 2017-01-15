module Envandle
  def self.options!(args)
    args.last.is_a?(Hash) ? args.pop : {}
  end

  def self.loc(level = 2)
    /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(level, 1).first
    Location.new($1, $2.to_i)
  end

  def self.pascal(s)
    s.split("_").map{|i| i.capitalize}.join("")
  end

  def self.reference_key(group, name)
    if group
      "#{name}@#{group}"
    else
      name
    end
  end
end
