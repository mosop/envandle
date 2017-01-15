module Envandle
  class GitBranchReference
    extend AsGitReference

    def initialize(context, group, name, url, ref)
      @context = context
      @group = group
      @name = name
      @url = url
      @ref = ref
    end

    def spec
      @spec ||= begin
        cache = @context.gemfile.gemspecs
        shas = Envandle.git_init(nil, @url) do |dir|
          Envandle.git_ls_remote_sha(dir, "refs/heads/#{@ref}")
        end
        sha = shas[0]
        cache_url = "#{@url}##{sha}"
        raise "Can't get a git commit. (url: #{@url}, branch: #{@ref})" unless sha
        dir = cache.find(cache_url) || begin
          reserve = cache.reserve
          Envandle.git_init reserve.path, @url
          sha = Envandle.git_pull(reserve.path, @ref, "master")
          reserve.url = cache_url
          reserve.save
          reserve.path
        end
        Gemspec.new(File.join(dir, "#{@name}.gemspec"))
      end
    end

    def to_executable_argset(base)
      args = base.dup
      args.clear_reference
      args.options[:git] = @url
      args.options[:branch] = @ref
      Argset.new(:gem, *args.args_and_options)
    end
  end
end
