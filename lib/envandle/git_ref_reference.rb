module Envandle
  class GitRefReference
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
        cache_url = "#{@url}##{@ref}"
        dir = cache.find(cache_url) || begin
          reserve = cache.reserve
          Envandle::GitUtil.init reserve.path, @url
          sha = Envandle::GitUtil.pull_sha(reserve.path, @ref, "master")
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
      args.options[:ref] = @ref
      Argset.new(:gem, *args.args_and_options)
    end
  end
end
