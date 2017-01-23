module Envandle
  module Elements
    class GroupBlock < Element
      extend AsContext

      class Dsl
        extend AsDsl

        dsl_method :gem
      end

      def initialize(*)
        super
        Envandle.arg! @loc, "No group names." if @args.args.empty?
      end

      def type
        :group_block
      end

      def groups
        @groups ||= @args.args.dup
      end

      def bundler_argsets
        @bundler_argsets ||= [].tap do |a|
          a << Argset.new(:group, *@args.args_and_options) do
            receiver = gemfile.bundler_receiver
            children.each do |child|
              child.send_to_bundler receiver
            end
          end
        end
      end

      def history_argsets
        @history_argsets ||= [].tap do |a|
          a << Argset.new(:group, *@args.args_and_options) do |history|
            children.each do |child|
              child.send_to_history history
            end
          end
        end
      end
    end
  end
end
