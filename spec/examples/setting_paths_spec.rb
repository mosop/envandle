require_relative "../spec_helper"

module EnvandleExampleSpecSettingPaths
  RSpec.describe name do
    let(:gemfile) do
      Envandle::Gemfile.new(nil, actual)
    end

    def draw
      bundle.gem "mygem", "~> 1.0"
    end

    context "with env", envandle: true do
      it do
        dir = File.join(__dir__, "setting_paths")
        ENV["ENVANDLE_GEM_PATH"] = "mygem:#{dir}"
        draw
        expect(actual.gem_argsets).to eq [
          ["mygem", {path: dir}]
        ]
      end
    end

    context "without env", envandle: true do
      it do
        draw
        expect(actual.gem_argsets).to eq [
          ["mygem", "~> 1.0"]
        ]
      end
    end
  end
end
