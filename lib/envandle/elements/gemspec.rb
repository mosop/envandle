module Envandle
  module Elements
    class Gemspec < Element
      extend AsContext

      def initialize(*)
        super
        dev_group = parse_string_option(:development_group, "gemspec's development group") || :development
        @development_group = dev_group ? dev_group.to_s.to_sym : :development
        @name = parse_string_option(:name, "gemspec's name")
        @path = parse_string_option(:path, "gemspec's path")
      end

      def type
        :gemspec
      end

      def bundler_argsets
        @bundler_argsets ||= begin
          [].tap do |a|
            path = @path || ::Envandle::Gemspec.find_file(gemfile.dir, name: @name)
            spec = ::Envandle::Gemspec.new(path)
            a << Argset.new(:gem, spec.name, path: ".")
            found = {}
            spec.dependencies.each do |i|
              group = i.type == :development ? @development_group : nil
              argset = Argset.new(nil, i.name, *i.requirements_list)
              argset.options[:group] = group if group
              gem = Gem.new(@loc, @context, *argset.args_and_options)
              gem.extract_bundler_argsets a, found
            end
          end
        end
      end
    end
  end
end
