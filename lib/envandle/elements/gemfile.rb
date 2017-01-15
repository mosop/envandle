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

      def initialize(file, binding, config_dir = nil)
        super Location.new(file, 1), nil
        @binding = binding
        @config_dir = config_dir
      end

      def binding_receiver
        @binding.receiver
      end

      def draw(&block)
        super
        exec
      end

      def exec
        receiver = @binding.receiver
        children.each do |child|
          child.exec receiver
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
