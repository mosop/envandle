require_relative "../spec_helper"

module EnvandleExampleSpecResolvingMultilevelDependencies
  RSpec.describe name do
    let(:gemfile) do
      Envandle::Elements::Gemfile.new(nil, test_binding, working_dir)
    end

    context "with env", envandle: true do
      it do
        dir = File.join(__dir__, "resolving_multilevel_dependencies")
        a_dir = File.join(dir, "a")
        b_dir = File.join(dir, "b")
        ENV["ENVANDLE_GEM_PATH"] = "a:#{a_dir};b:#{b_dir}"
        gemfile.draw do
          source "https://rubygems.org"
          gem "a", "~> 1.0"
        end
        expect(actual).to eq [
          [:source, "https://rubygems.org"],
          [:gem, "b", {path: b_dir}],
          [:gem, "a", {path: a_dir}]
        ]
        expect(gemfile.history.argsets).to eq test_binding.argsets
      end
    end
  end
end
