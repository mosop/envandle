module Envandle
  class BundleDsl
    def initialize(gemfile)
      @gemfile = gemfile
    end

    def gem(*args)
      @gemfile.gem nil, *args
    end

    def group(name)
      yield GroupDsl.new(@gemfile, name)
    end

    def gemspec(development_group: "development", path: nil, name: nil)
      development_group = development_group.to_s.strip
      raise "No gemspec's development group." if development_group.empty?
      name = name.to_s.strip if name
      raise "No gemspec's name." if name && name.empty
      path ||= Gemspec.find_file(@gemfile.dir, name: name)
      path = path.to_s.strip
      raise "No gemspec's path." if path.empty?
      spec = Gemspec.new(path)
      @gemfile.gem nil, spec.name, path: "."
      spec.dependencies.each do |i|
        group = i.type == :development ? development_group : nil
        @gemfile.gem group, i.name, *i.requirements_list
      end
    end
  end
end
