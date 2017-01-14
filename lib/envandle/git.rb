module Envandle
  GIT = `which git`.chomp

  def self.git_pull(url, ref, branch)
    raise "No git installed." if GIT.empty?
    Dir.mktmpdir do |tmp|
      Dir.chdir(tmp) do
        sh "#{GIT} init"
        sh "#{GIT} remote add origin #{url}"
        sh "#{GIT} checkout -b #{branch}"
        sh "#{GIT} pull origin #{ref}:#{branch}"
        yield tmp
      end
    end
  end
end
