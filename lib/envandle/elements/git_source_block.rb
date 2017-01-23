module Envandle
  module Elements
    class GitSourceBlock < Element
      def draw
      end

      def type
        :git_source_block
      end

      def bundler_argsets
        @bundler_argsets ||= [].tap do |a|
          a << Argset.new(:git_source, *@args.args_and_options, &@args.block)
        end
      end

      def history_argsets
        @history_argsets ||= [].tap do |a|
          a << Argset.new(:git_source, *@args.args_and_options, @args.block.class.name)
        end
      end
    end
  end
end
