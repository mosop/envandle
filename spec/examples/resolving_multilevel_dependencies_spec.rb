require_relative "../spec_helper"

module EnvandleExampleSpecResolvingMultilevelDependencies
  RSpec.describe name do
    let(:gemfile) do
      Envandle::Gemfile.new(nil, actual)
    end

    context "with env", envandle: true do
      it do
        dir = File.join(__dir__, "resolving_multilevel_dependencies")
        a_dir = File.join(dir, "a")
        b_dir = File.join(dir, "b")
        ENV["ENVANDLE_GEM_PATH"] = "a:#{a_dir};b:#{b_dir}"
        bundle.gem "a", "~> 1.0"
        expect(actual.gem_argsets).to eq [
          ["b", {path: b_dir}],
          ["a", {path: a_dir}]
        ]
      end
    end
  end
end
