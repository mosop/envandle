module Envandle
  class ReferenceCache
    def self.key(group, name)
      if group
        "#{name}@#{group}"
      else
        name
      end
    end

    def find(key, name)
      paths[key] ||
      git_branches[key] ||
      paths[name] ||
      git_branches[name]
    end

    def paths
      @paths ||= parse(:path, PathReference, "ENVANDLE_GEM_PATH")
    end

    def git_branches
      @git_branches ||= parse(:git, GitBranchReference, "ENVANDLE_GEM_GIT_BRANCH")
    end

    def parse(key, klass, env)
      {}.tap do |h|
        (ENV[env].to_s).split(";").each do |i|
          if v = __send__("parse_#{key}", klass, env, i)
            h[v.key] = v if v
          end
        end
      end
    end

    def parse_group_and_name(env, v)
      name, group = v.to_s.strip.split("@")
      name = name.to_s.strip
      group = group.to_s.strip if group
      raise "No gem name (#{env}): #{ENV[env]}" if name.empty?
      raise "No group name (#{env}): #{ENV[env]}" if group && group.empty?
      [group, name]
    end

    def parse_path(klass, env, v)
      v = v.to_s.strip
      return if v.empty?
      a = v.split(":")
      name = a[0].to_s.strip
      path = a[1..-1].join(":").to_s.strip
      raise "No gem path (#{env}): #{ENV[env]}" if path.empty?
      klass.new(*parse_group_and_name(env, name), path)
    end

    def parse_git(klass, env, v)
      v = v.to_s.strip
      return if v.empty?
      a = v.split(":")
      name = a[0].to_s.strip
      path = a[1..-1].join(":").to_s.strip
      url_and_ref = path.split('#')
      url = url_and_ref[0].to_s.strip
      ref = url_and_ref[1].to_s.strip
      raise "No gem git url (#{env}): #{ENV[env]}" if url.empty?
      raise "No gem git ref/branch/tag (#{env}): #{ENV[env]}" if ref.empty?
      klass.new(*parse_group_and_name(env, name), url, ref)
    end
  end
end
