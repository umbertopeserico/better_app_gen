# frozen_string_literal: true

RSpec.describe BetterAppGen::CLI do
  describe ".exit_on_failure?" do
    it "returns true" do
      expect(described_class.exit_on_failure?).to be true
    end
  end

  describe "#version" do
    it "outputs the version" do
      expect { described_class.new.version }
        .to output("better_app_gen v#{BetterAppGen::VERSION}\n").to_stdout
    end
  end
end
