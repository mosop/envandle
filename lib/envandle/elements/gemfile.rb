module Envandle
  module Elements
    class Gemfile < Element
      extend AsContext

      class Dsl
        extend AsDsl

        dsl_method :source
        dsl_method :group
        dsl_method :gem
        dsl_method :gemspec
        dsl_method :git_source
      end

      DUMP = ENV["ENVANDLE_DUMP"].to_s

      def initialize(file, binding, config_dir = nil)
        super Location.new(file, 1), nil
        @bundler_binding = dumps? ? History.new : binding
        @config_dir = config_dir
      end

      def bundler_receiver
        @bundler_binding.receiver
      end

      def history
        @history ||= History.new
      end

      def draw(&block)
        super
        exec
        dump if dumps?
      end

      def dumps?
        !DUMP.empty?
      end

      def dump
        dump_file do |f|
          f << JSON.pretty_generate(history.argsets)
        end
      end

      def dump_file(&block)
        case DUMP
        when "1"
          yield $stdout
        when "2"
          yield $stderr
        else
          File.open DUMP, "w", &block
        end
      end

      def exec
        receiver = bundler_receiver
        children.each do |child|
          child.send_to_bundler receiver
          child.send_to_history history
        end
        references.left.each do |k, v|
          v.to_executable_argset(Argset.new(nil)).send_to receiver
        end
      end

      def dir
        @dir ||= File.dirname(@loc.file)
      end

      def config_dir
        @config_dir ||= File.join(dir, ".envandle")
      end

      def gemfile
        self
      end

      def references
        @references ||= ReferenceCache.new(self)
      end

      def gem_keys
        @gem_keys ||= {}
      end

      def gemspecs
        @gemspecs ||= GemspecCache.new(File.join(config_dir, "cache", "gemspecs"))
      end

      def sources
        children_by_type(:source)
      end

      def source_urls
        sources.map{|i| i.url}
      end

      def groups
        []
      end
    end
  end
end
