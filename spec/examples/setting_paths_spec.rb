require_relative "../spec_helper"

module EnvandleExampleSpecSettingPaths
  RSpec.describe name do
    let(:gemfile) do
      Envandle::Elements::Gemfile.new(nil, test_binding, working_dir)
    end

    def draw
      gemfile.draw do
        source "https://rubygems.org"
        gem "mygem", "~> 1.0"
      end
    end

    context "with env", envandle: true do
      it do
        dir = File.join(__dir__, "setting_paths")
        ENV["ENVANDLE_GEM_PATH"] = "mygem:#{dir}"
        draw
        expect(actual).to eq [
          [:source, "https://rubygems.org"],
          [:gem, "mygem", {path: dir}]
        ]
        expect(gemfile.history.argsets).to eq test_binding.argsets
      end
    end

    context "without env", envandle: true do
      it do
        draw
        expect(actual).to eq [
          [:source, "https://rubygems.org"],
          [:gem, "mygem", "~> 1.0"]
        ]
        expect(gemfile.history.argsets).to eq test_binding.argsets
      end
    end
  end
end
