module Envandle
  class Gemfile
    def initialize(path, binding)
      @path = path
      @binding = binding
    end

    def dir
      @dir ||= File.dirname(@path)
    end

    def gems
      @gems ||= {}
    end

    def references
      @references ||= ReferenceCache.new
    end

    def append(group, name, args, options)
      key = ReferenceCache.key(group, name)
      gems[key] || begin
        if ref = references.find(key, name)
          gem = ref.to_gem(args, options)
          gems[key] = gem
          ref.spec.runtime_dependencies.each do |i|
            append nil, i.name, [], {}
          end
          @binding.gem *gem.args
        else
          gems[key] = gem = Gem.new(group, name, args, options)
          @binding.gem *gem.args
        end
      end
    end

    def gem(group, *args)
      h = args.last.is_a?(Hash) ? args.pop : {}
      options = {}
      h.each do |k, v|
        options[k.to_s.to_sym] = v
      end
      name = args.shift.to_s.strip
      raise "No gem name." if name.empty?
      append group, name, args, options
    end
  end
end
