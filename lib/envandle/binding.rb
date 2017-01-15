require "envandle/lib"

class Binding
  def envandle(&block)
    ::Envandle::Elements::Gemfile.new(::Envandle.loc.file, self).draw &block
  end
end
