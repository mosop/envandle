$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "envandle"

module Envandle
  module Rspec
    module Context
      extend ::RSpec::SharedContext

      before(:context) do
        @__last_gem_path_env = ENV["ENVANDLE_GEM_PATH"]
        @__last_gem_git_branch_env = ENV["ENVANDLE_GEM_GIT_BRANCH"]
        ENV["ENVANDLE_GEM_PATH"] = ""
        ENV["ENVANDLE_GEM_GIT_BRANCH"] = ""
      end

      after(:context) do
        ENV["ENVANDLE_GEM_PATH"] = @__last_gem_path_env
        ENV["ENVANDLE_GEM_GIT_BRANCH"] = @__last_gem_git_branch_env
      end

      let(:actual) do
        Envandle::TestBinding.new
      end

      let(:bundle) do
        Envandle::BundleDsl.new(gemfile)
      end
    end
  end

  class TestBinding
    def gem_argsets
      @gem_argsets ||= []
    end

    def gem(*args)
      gem_argsets << args
    end
  end
end

RSpec.configure do |c|
  c.disable_monkey_patching!
  c.include Envandle::Rspec::Context, :envandle
end
