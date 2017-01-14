require_relative "../spec_helper"

module EnvandleExampleSpecSettingBranches
  RSpec.describe name do
    let(:gemfile) do
      Envandle::Gemfile.new(nil, actual)
    end

    def draw
      bundle.gem "envandle-test1", "~> 1.0"
    end

    context "with env", envandle: true do
      it do
        ENV["ENVANDLE_GEM_GIT_BRANCH"] = "envandle-test1:https://github.com/mosop/envandle-test1.git#edge"
        draw
        expect(actual.gem_argsets).to eq [
          ["envandle-test1", {git: "https://github.com/mosop/envandle-test1.git", branch: "edge"}]
        ]
      end
    end

    context "without env", envandle: true do
      it do
        draw
        expect(actual.gem_argsets).to eq [
          ["envandle-test1", "~> 1.0"]
        ]
      end
    end
  end
end
