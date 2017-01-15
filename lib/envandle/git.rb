module Envandle
  GIT_BIN = `which git`.chomp

  def self.raise_if_no_git_installed
    raise "No git installed." if GIT_BIN.empty?
  end

  def self.git_init(dir, url, &block)
    unless dir
      Dir.mktmpdir do |tmpdir|
        git_init tmpdir, url, &block
      end
    else
      raise_if_no_git_installed
      Dir.chdir(dir) do
        sh "#{GIT_BIN} init"
        sh "#{GIT_BIN} remote add origin #{url}"
        yield dir if block_given?
      end
    end
  end

  def self.git_ls_remote_sha(dir, q)
    Dir.chdir(dir) do
      data = sh("#{GIT_BIN} ls-remote origin #{q}").chomp
      data = if data.empty?
        []
      else
        data.split("\n").map{|i| i.split(/\s+/)[0] }
      end
      if block_given?
        yield data
      else
        data
      end
    end
  end

  def self.git_pull(dir, ref, branch)
    Dir.chdir(dir) do
      sh "#{GIT_BIN} checkout -b #{branch}"
      sh "#{GIT_BIN} pull origin #{ref}:#{branch}"
      sha = sh("#{GIT_BIN} rev-parse HEAD").chomp
      if block_given?
        yield sha
      else
        sha
      end
    end
  end
end
