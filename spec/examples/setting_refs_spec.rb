require_relative "../spec_helper"

module EnvandleExampleSpecSettingRefs
  RSpec.describe name do
    let(:gemfile) do
      Envandle::Elements::Gemfile.new(nil, test_binding, working_dir)
    end

    def draw
      gemfile.draw do
        source "https://rubygems.org"
        gem "envandle-test1", "~> 1.0"
      end
    end

    context "with env", envandle: true do
      it do
        ENV["ENVANDLE_GEM_GIT_REF"] = "envandle-test1:https://github.com/mosop/envandle-test1.git#aed3d9b9965b6938cca7490e98423cf9b5908b09"
        draw
        expect(actual).to eq [
          [:source, "https://rubygems.org"],
          [:gem, "envandle-test1", {git: "https://github.com/mosop/envandle-test1.git", ref: "aed3d9b9965b6938cca7490e98423cf9b5908b09"}]
        ]
        expect(gemfile.history.argsets).to eq test_binding.argsets
        expect(gemfile.gemspecs.find("https://github.com/mosop/envandle-test1.git#aed3d9b9965b6938cca7490e98423cf9b5908b09")).not_to be_nil
      end
    end

    context "without env", envandle: true do
      it do
        draw
        expect(actual).to eq [
          [:source, "https://rubygems.org"],
          [:gem, "envandle-test1", "~> 1.0"]
        ]
        expect(gemfile.history.argsets).to eq test_binding.argsets
      end
    end
  end
end
