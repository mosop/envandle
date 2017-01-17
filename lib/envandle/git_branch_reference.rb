module Envandle
  class GitBranchReference
    extend AsGitReference

    def initialize(context, name, url, ref)
      @context = context
      @name = name
      @url = url
      @ref = ref
    end

    def spec
      @spec ||= begin
        cache = @context.gemfile.gemspecs
        shas = Envandle::GitUtil.init(nil, @url) do |dir|
          Envandle::GitUtil.ls_remote_sha(dir, "refs/heads/#{@ref}")
        end
        sha = shas[0]
        cache_url = "#{@url}##{sha}"
        raise "Can't get a git commit. (url: #{@url}, branch: #{@ref})" unless sha
        dir = cache.find(cache_url) || begin
          reserve = cache.reserve
          Envandle::GitUtil.init reserve.path, @url
          sha = Envandle::GitUtil.pull(reserve.path, @ref, "master")
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
      args.args[0] = @name
      args.options[:git] = @url
      args.options[:branch] = @ref
      Argset.new(:gem, *args.args_and_options)
    end
  end
end
