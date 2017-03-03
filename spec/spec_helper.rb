$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "envandle"

module Envandle
  module Rspec
    module Context
      extend ::RSpec::SharedContext

      before(:context) do
        @__last_gem_path_env = ENV["ENVANDLE_GEM_PATH"]
        @__last_gem_git_branch_env = ENV["ENVANDLE_GEM_GIT_BRANCH"]
        @__last_gem_git_ref_env = ENV["ENVANDLE_GEM_GIT_REF"]
        ENV["ENVANDLE_GEM_PATH"] = ""
        ENV["ENVANDLE_GEM_GIT_BRANCH"] = ""
        tmpdir = File.expand_path("../tmp", __dir__)
        FileUtils.mkdir_p tmpdir
        @__working_dir = Envandle.tmpdir(nil, tmpdir)
      end

      after(:context) do
        ENV["ENVANDLE_GEM_PATH"] = @__last_gem_path_env
        ENV["ENVANDLE_GEM_GIT_BRANCH"] = @__last_gem_git_branch_env
        ENV["ENVANDLE_GEM_GIT_REF"] = @__last_gem_git_ref_env
        FileUtils.remove_entry_secure @__working_dir, true if @__working_dir
      end

      let(:test_binding) do
        Envandle::TestBinding.new
      end

      let(:actual) do
        test_binding.argsets
      end

      let(:working_dir) do
        @__working_dir
      end
    end
  end

  class TestBinding
    def receiver
      self
    end

    def argsets
      @argsets ||= []
    end

    def add_argset(type, *args, &block)
      a = [type, *args]
      argsets << a
      if block
        _argsets = @argsets
        @argsets = []
        begin
          block.call
        ensure
          a << @argsets
          @argsets = _argsets
        end
      end
    end

    def add_argset_with_block(type, *args, &block)
      add_argset type, *[*args, block ? block.class.name : nil]
    end

    def gem(*args, &block)
      add_argset :gem, *args, &block
    end

    def gemspec(*args, &block)
      add_argset :gemspec, *args, &block
    end

    def git_source(*args, &block)
      add_argset_with_block :git_source, *args, &block
    end

    def group(*args, &block)
      add_argset :group, *args, &block
    end

    def source(*args, &block)
      add_argset :source, *args, &block
    end
  end
end

RSpec.configure do |c|
  c.disable_monkey_patching!
  c.include Envandle::Rspec::Context, :envandle
end
