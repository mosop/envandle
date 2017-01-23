require_relative "../spec_helper"

module EnvandleExampleSpecSpecifyingGemspecs
  RSpec.describe name do
    let(:dir) do
      File.join(__dir__, "specifying_gemspecs")
    end

    let(:gemfile) do
      Envandle::Elements::Gemfile.new(File.join(dir, "current", "Gemfile"), test_binding, working_dir)
    end

    def draw
      gemfile.draw do
        source "https://rubygems.org"
        gemspec
      end
    end

    context "with env", envandle: true do
      it do
        a_dir = File.join(dir, "a")
        b_dir = File.join(dir, "b")
        ENV["ENVANDLE_GEM_PATH"] = "a:#{a_dir};b:#{b_dir}"
        draw
        expect(actual).to eq [
          [:source, "https://rubygems.org"],
          [:gem, "test", {path: "."}],
          [:gem, "a", {path: a_dir}],
          [:gem, "b", {path: b_dir}],
          [:gem, "c", "~> 1.0"]
        ]
        expect(gemfile.history.argsets).to eq test_binding.argsets
      end
    end

    context "without env", envandle: true do
      it do
        draw
        expect(actual).to eq [
          [:source, "https://rubygems.org"],
          [:gem, "test", {path: "."}],
          [:gem, "a", "~> 1.0"],
          [:gem, "b", "~> 1.0"],
          [:gem, "c", "~> 1.0"]
        ]
        expect(gemfile.history.argsets).to eq test_binding.argsets
      end
    end
  end
end
