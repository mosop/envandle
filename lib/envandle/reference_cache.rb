module Envandle
  class ReferenceCache
    def initialize(context)
      @context = context
    end

    def use(name)
      if ref = all[name]
        left.delete name
        ref
      end
    end

    def paths
      @paths ||= parse(:path, PathReference, "ENVANDLE_GEM_PATH")
    end

    def git_branches
      @git_branches ||= parse(:git, GitBranchReference, "ENVANDLE_GEM_GIT_BRANCH")
    end

    def git_refs
      @git_refs ||= parse(:git, GitRefReference, "ENVANDLE_GEM_GIT_REF")
    end

    def all
      @all ||= git_branches.merge(git_refs.merge(paths))
    end

    def left
      @left ||= all.dup
    end

    def parse(key, klass, env)
      {}.tap do |h|
        (ENV[env].to_s).split(";").each do |i|
          if v = __send__("parse_#{key}", klass, env, i)
            h[v.name] = v if v
          end
        end
      end
    end

    def parse_name(env, v)
      v = v.to_s.strip
      raise "No gem name (#{env}): #{ENV[env]}" if v.empty?
      v
    end

    def parse_path(klass, env, v)
      v = v.to_s.strip
      return if v.empty?
      a = v.split(":")
      name = a[0].to_s.strip
      path = a[1..-1].join(":").to_s.strip
      raise "No gem path (#{env}): #{ENV[env]}" if path.empty?
      klass.new(@context, parse_name(env, name), path)
    end

    def parse_git(klass, env, v)
      v = v.to_s.strip
      return if v.empty?
      a = v.split(":")
      name = a[0]
      path = a[1..-1].join(":").to_s.strip
      url_and_ref = path.split('#')
      url = url_and_ref[0].to_s.strip
      ref = url_and_ref[1].to_s.strip
      raise "No gem git url (#{env}): #{ENV[env]}" if url.empty?
      raise "No gem git ref/branch/tag (#{env}): #{ENV[env]}" if ref.empty?
      klass.new(@context, parse_name(env, name), url, ref)
    end

    def extract_bundler_argsets(base, group, name, argsets, found = {})
      key = Envandle.reference_key(group, name)
      return true if found.key?(key)
      found[key] = true
      if ref = use(name)
        ref.spec.runtime_dependencies.each do |i|
          if ref2 = use(i.name)
            extract_bundler_argsets base, nil, i.name, argsets, found
          end
        end
        args = base.dup
        args.args[0] = name
        argsets << ref.to_executable_argset(args)
        true
      else
        false
      end
    end
  end
end
