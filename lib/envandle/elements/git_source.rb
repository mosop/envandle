module Envandle
  module Elements
    class GitSource < IllegalElement
      def type
        "git_source without block"
      end
    end
  end
end
