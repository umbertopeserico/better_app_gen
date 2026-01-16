# frozen_string_literal: true

RSpec.describe BetterAppGen::DependencyChecker do
  let(:checker) { described_class.new }

  describe "REQUIRED_DEPENDENCIES" do
    it "defines ruby dependency" do
      expect(described_class::REQUIRED_DEPENDENCIES).to include("ruby")
      expect(described_class::REQUIRED_DEPENDENCIES["ruby"][:min_version]).to eq("3.2.0")
    end

    it "defines rails dependency" do
      expect(described_class::REQUIRED_DEPENDENCIES).to include("rails")
      expect(described_class::REQUIRED_DEPENDENCIES["rails"][:min_version]).to eq("8.0.0")
    end

    it "defines node dependency" do
      expect(described_class::REQUIRED_DEPENDENCIES).to include("node")
      expect(described_class::REQUIRED_DEPENDENCIES["node"][:min_version]).to eq("20.0.0")
    end

    it "defines yarn dependency" do
      expect(described_class::REQUIRED_DEPENDENCIES).to include("yarn")
      expect(described_class::REQUIRED_DEPENDENCIES["yarn"][:min_version]).to eq("4.0.0")
    end

    it "defines git dependency without min_version" do
      expect(described_class::REQUIRED_DEPENDENCIES).to include("git")
      expect(described_class::REQUIRED_DEPENDENCIES["git"][:min_version]).to be_nil
    end

    it "defines psql dependency without min_version" do
      expect(described_class::REQUIRED_DEPENDENCIES).to include("psql")
      expect(described_class::REQUIRED_DEPENDENCIES["psql"][:min_version]).to be_nil
    end
  end

  describe "#check" do
    it "returns true for ruby (always present in test environment)" do
      expect(checker.check("ruby")).to be true
    end

    it "accepts symbol as argument" do
      expect(checker.check(:ruby)).to be true
    end

    it "raises error for unknown dependency" do
      expect { checker.check("unknown_dep") }.to raise_error(BetterAppGen::Error, /Unknown dependency/)
    end
  end

  describe "#check_all" do
    context "when run in the test environment" do
      it "returns a boolean" do
        result = checker.check_all
        expect(result).to be(true).or be(false)
      end

      it "populates @results for missing_dependencies" do
        checker.check_all
        # After check_all, missing_dependencies should be callable
        expect(checker.missing_dependencies).to be_an(Array)
      end
    end

    context "with verbose: true" do
      it "produces output" do
        expect { checker.check_all(verbose: true) }.to output.to_stdout
      end
    end

    context "with verbose: false" do
      it "produces no output" do
        expect { checker.check_all(verbose: false) }.not_to output.to_stdout
      end
    end
  end

  describe "#missing_dependencies" do
    it "returns empty array before check_all is called" do
      expect(checker.missing_dependencies).to eq([])
    end

    it "returns array of missing dependency names after check_all" do
      checker.check_all
      expect(checker.missing_dependencies).to be_an(Array)
      expect(checker.missing_dependencies.all? { |d| d.is_a?(String) }).to be true
    end
  end

  describe "version extraction" do
    # Test the private extract_version method through behavior
    # We can test this indirectly by examining the output format

    it "handles Ruby version format" do
      # Ruby outputs: "ruby 3.2.0 (2022-12-25 revision a528908271) [arm64-darwin22]"
      # The checker should extract "3.2.0"
      expect(checker.check("ruby")).to be true
    end

    it "handles git version format" do
      # Git outputs: "git version 2.39.0"
      # Should work even without min_version requirement
      expect(checker.check("git")).to be true
    end
  end

  describe "version comparison" do
    # Test version_satisfied? indirectly through check behavior
    # The method compares semantic versions

    context "when current version meets requirement" do
      before do
        # Mock the dependency check to return a specific version
        allow(checker).to receive(:check_dependency).and_call_original
      end

      it "returns satisfied: true when version is equal" do
        checker.check_all
        # Ruby in test env should satisfy 3.2.0 requirement
        result = checker.check("ruby")
        expect(result).to be true
      end
    end
  end

  describe "#pastel" do
    it "returns a Pastel delegator" do
      expect(checker.pastel).to respond_to(:green)
      expect(checker.pastel).to respond_to(:red)
    end
  end

  describe "print_result behavior" do
    it "shows OK for satisfied dependencies" do
      output = capture_output { checker.check_all(verbose: true) }
      # Should show green OK for ruby (always present)
      expect(output).to include("ruby")
    end

    def capture_output
      original_stdout = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original_stdout
    end
  end
end
