module Envandle
  module Elements
    class Gem < Element
      def initialize(*)
        super
        @name = parse_string_value(@args.args[0].to_s, "gem name")
      end

      def type
        :gem
      end

      def extract_bundler_argsets(a, cache)
        found = false
        @args.contextual_groups.each do |group|
          if gemfile.references.extract_bundler_argsets(@args, group, @name, a, cache)
            found = true
          end
        end
        a << Argset.new(:gem, *@args.args_and_options) unless found
      end

      def bundler_argsets
        @bundler_argsets ||= [].tap do |a|
          extract_bundler_argsets a, {}
        end
      end
    end
  end
end
