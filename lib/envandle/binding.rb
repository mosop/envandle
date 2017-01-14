require "envandle/lib"

class Binding
  def envandle
    /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller(1, 1).first
    yield ::Envandle::BundleDsl.new(::Envandle::Gemfile.new($1, self))
  end

  def gem(*args)
    receiver.__send__ :gem, *args
  end
end
