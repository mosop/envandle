module Envandle
  module Elements
    class GitSourceBlock < Element
      def draw
      end

      def type
        :git_source_block
      end

      def executable_argsets
        @executable_argsets ||= [].tap do |a|
          a << Argset.new(:git_source, *@args.args_and_options, &@args.block)
        end
      end
    end
  end
end
