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

      def executable_argsets
        @executable_argsets ||= [].tap do |a|
          a << Argset.new(:group, *@args.args_and_options) do
            children.each do |child|
              child.exec gemfile.binding_receiver
            end
          end
        end
      end
    end
  end
end
