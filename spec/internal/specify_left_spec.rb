require_relative "../spec_helper"

module EnvandleInternalSpecSpecifyLeft
  RSpec.describe name, envandle: true do
    let(:gemfile) do
      Envandle::Elements::Gemfile.new(nil, test_binding, working_dir)
    end

    it "works" do
      dir = File.join(__dir__, "specify_left")
      ENV["ENVANDLE_GEM_PATH"] = "a:#{dir};b:b-path"
      ENV["ENVANDLE_GEM_GIT_BRANCH"] = "envandle-test1:https://github.com/mosop/envandle-test1.git#edge;c:c-url#c-branch"
      gemfile.draw do
        gem "a"
        gem "envandle-test1"
      end
      expect(actual).to eq [
        [:gem, "a", path: dir],
        [:gem, "envandle-test1", git: "https://github.com/mosop/envandle-test1.git", branch: "edge"],
        [:gem, "c", git: "c-url", branch: "c-branch"],
        [:gem, "b", path: "b-path"]
      ]
      expect(gemfile.history.argsets).to eq [
        [:gem, "a", path: dir],
        [:gem, "envandle-test1", git: "https://github.com/mosop/envandle-test1.git", branch: "edge"]
      ]
    end
  end
end
