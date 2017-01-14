require_relative "../spec_helper"

module EnvandleExampleSpecSpecifyingGemspecs
  RSpec.describe name do
    let(:dir) do
      File.join(__dir__, "specifying_gemspecs")
    end

    let(:gemfile) do
      Envandle::Gemfile.new(File.join(dir, "current", "Gemfile"), actual)
    end

    def draw
      bundle.gemspec
    end

    context "with env", envandle: true do
      it do
        a_dir = File.join(dir, "a")
        b_dir = File.join(dir, "b")
        ENV["ENVANDLE_GEM_PATH"] = "a:#{a_dir};b:#{b_dir}"
        draw
        expect(actual.gem_argsets).to eq [
          ["test", {path: "."}],
          ["a", {path: a_dir}],
          ["b", {path: b_dir}],
          ["c", "~> 1.0"]
        ]
      end
    end

    context "without env", envandle: true do
      it do
        draw
        expect(actual.gem_argsets).to eq [
          ["test", {path: "."}],
          ["a", "~> 1.0"],
          ["b", "~> 1.0"],
          ["c", "~> 1.0"]
        ]
      end
    end
  end
end
