require_relative "../spec_helper"

module EnvandleInternalSpecSpecifyLeft
  RSpec.describe name, envandle: true do
    let(:gemfile) do
      Envandle::Elements::Gemfile.new(nil, test_binding, working_dir)
    end

    it "source with block" do
      expect(){
        gemfile.draw do
          source do
          end
        end
      }.to raise_error(Envandle::UnsupportedElement)
    end

    it "gem with block" do
      expect(){
        gemfile.draw do
          gem do
          end
        end
      }.to raise_error(Envandle::IllegalElement)
    end

    it "git_source without block" do
      expect(){
        gemfile.draw do
          git_source
        end
      }.to raise_error(Envandle::IllegalElement)
    end

    it "group without block" do
      expect(){
        gemfile.draw do
          group
        end
      }.to raise_error(Envandle::IllegalElement)
    end
  end
end
