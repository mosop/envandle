module Envandle
  class Gemspec
    def initialize(path)
      @path = path
      @native = ::Gem::Specification.load(path)
    end

    def self.find_file(dir, name:)
      name ||= "*"
      Dir.glob(File.join(dir, "#{name}.gemspec")) do |f|
        return f
      end
      nil
    end

    def name
      @native.name
    end

    def dependencies
      @native.dependencies
    end

    def runtime_dependencies
      @native.runtime_dependencies
    end
  end
end
