# frozen_string_literal: true

RSpec.describe BetterAppGen do
  it "has a version number" do
    expect(BetterAppGen::VERSION).not_to be_nil
  end

  describe ".root" do
    it "returns a Pathname" do
      expect(described_class.root).to be_a(Pathname)
    end

    it "points to the gem root directory" do
      expect(described_class.root.join("lib", "better_app_gen.rb")).to exist
    end
  end

  describe ".templates_path" do
    it "returns a Pathname" do
      expect(described_class.templates_path).to be_a(Pathname)
    end

    it "points to the templates directory" do
      expect(described_class.templates_path).to exist
    end
  end
end
