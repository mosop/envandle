module Envandle
  class GemBlock < IllegalElement
    def type
      "gem with block"
    end
  end

  class GemspecBlock < IllegalElement
    def type
      "gemspec with block"
    end
  end

  class GitSource < IllegalElement
    def type
      "git_source without block"
    end
  end

  class Group < IllegalElement
    def type
      "group without block"
    end
  end

  class SourceBlock < UnsupportedElement
    def type
      "source with block"
    end
  end
end
