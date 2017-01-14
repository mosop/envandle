module Envandle
  class GitBranchReference
    extend AsGitReference

    def initialize(group, name, url, ref)
      @group = group
      @name = name
      @url = url
      @ref = ref
    end

    def to_gem(args, options)
      Gem.new(@group, @name, [], {git: @url, branch: @ref})
    end

    def spec
      Envandle.git_pull(@url, @ref, @ref) do |dir|
        Gemspec.new(File.join(dir, "#{@name}.gemspec"))
      end
    end
  end
end
