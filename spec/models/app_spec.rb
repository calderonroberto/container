require 'spec_helper'
require 'capybara/rails'

describe App do

  before do
    @app = App.new(name: "Application", 
                       description: "Application description",
                       url: "http://localhost/",
                       thumbnail_url: "http://localhost/")
  end
  subject { @app }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:url) }
  it { should respond_to(:thumbnail_url) }
  it { should respond_to(:subscriptions) }
  it { should respond_to(:subscribed?) }
  it { should respond_to(:subscribe!) }
  it { should respond_to(:unsubscribe!) }
  it { should respond_to(:stagings) }
  it { should respond_to(:staged_displays) }

  it { should be_valid }

  describe "when name is not present" do
    before { @app.name = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @app.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when description is not present" do
    before { @app.description = "" }
    it { should_not be_valid }
  end

  describe "when url is not present" do
    before { @app.url = "" }
    it { should_not be_valid }
  end
 
  describe "when url format is invalid" do
    it "should be invalid" do
      addresses = %w[url url.com htp://url htp://url.com]
      addresses.each do |invalid_address|
	@app.url = invalid_address
	@app.should_not be_valid
      end
    end
  end

end
