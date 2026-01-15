# frozen_string_literal: true

RSpec.describe BetterAppGen::Generators::HomeController, :generator do
  let(:generator) { described_class.new(config) }

  describe "#generate!" do
    before { generator.generate! }

    it "creates app/views/home directory" do
      expect(File.directory?(file_path("app/views/home"))).to be true
    end

    it "creates HomeController" do
      expect(file_exists?("app/controllers/home_controller.rb")).to be true
    end

    it "creates HomeHelper" do
      expect(file_exists?("app/helpers/home_helper.rb")).to be true
    end

    it "creates index view" do
      expect(file_exists?("app/views/home/index.html.erb")).to be true
    end

    it "creates routes.rb" do
      expect(file_exists?("config/routes.rb")).to be true
    end

    describe "HomeController content" do
      it "defines HomeController class" do
        content = read_generated_file("app/controllers/home_controller.rb")
        expect(content).to include("class HomeController")
      end

      it "inherits from ApplicationController" do
        content = read_generated_file("app/controllers/home_controller.rb")
        expect(content).to include("< ApplicationController")
      end

      it "defines index action" do
        content = read_generated_file("app/controllers/home_controller.rb")
        expect(content).to include("def index")
      end
    end

    describe "HomeHelper content" do
      it "defines HomeHelper module" do
        content = read_generated_file("app/helpers/home_helper.rb")
        expect(content).to include("module HomeHelper")
      end
    end

    describe "routes.rb content" do
      it "defines root route" do
        content = read_generated_file("config/routes.rb")
        expect(content).to include("root")
      end

      it "routes to home#index" do
        content = read_generated_file("config/routes.rb")
        expect(content).to match(/root.*home#index|root.*"home#index"/)
      end
    end
  end
end
