module Envandle
  module GitUtil
    BIN = `which git`.chomp

    def self.raise_if_no_git_installed
      raise "No git installed." if BIN.empty?
    end

    def self.init(dir, url, &block)
      unless dir
        Envandle.tmpdir do |tmpdir|
          init tmpdir, url, &block
        end
      else
        raise_if_no_git_installed
        Dir.chdir(dir) do
          Envandle.sh "#{BIN} init"
          Envandle.sh "#{BIN} remote add origin #{url}"
          yield dir if block_given?
        end
      end
    end

    def self.ls_remote_sha(dir, q)
      Dir.chdir(dir) do
        data = Envandle.sh("#{BIN} ls-remote origin #{q}").chomp
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

    def self.pull(dir, ref, branch)
      Dir.chdir(dir) do
        Envandle.sh "#{BIN} checkout -b #{branch}"
        Envandle.sh "#{BIN} pull origin #{ref}:#{branch}"
        sha = Envandle.sh("#{BIN} rev-parse HEAD").chomp
        if block_given?
          yield sha
        else
          sha
        end
      end
    end
  end
end
