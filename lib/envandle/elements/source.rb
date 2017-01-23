module Envandle
  module Elements
    class Source < Element
      def type
        :source
      end

      def bundler_argsets
        @bundler_argsets ||= [].tap do |a|
          a << Argset.new(:source, *@args.args_and_options)
        end
      end
    end
  end
end
