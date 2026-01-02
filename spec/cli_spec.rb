# frozen_string_literal: true

RSpec.describe BetterAppgen::CLI do
  describe ".exit_on_failure?" do
    it "returns true" do
      expect(described_class.exit_on_failure?).to be true
    end
  end

  describe "#version" do
    it "outputs the version" do
      expect { described_class.new.version }
        .to output("better_appgen v#{BetterAppgen::VERSION}\n").to_stdout
    end
  end
end
