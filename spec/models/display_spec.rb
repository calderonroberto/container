require 'spec_helper'
require 'capybara/rails'

describe Display do

  before do
    @display = Display.new(name: "Display", 
                            password: "foobar", 
                            password_confirmation: "foobar")
    @second_display = Display.new(name: "Second Display", 
                            password: "foobar", 
                            password_confirmation: "foobar")
    @app = App.new(name: Time.now.to_s,
                    description: "Description",
                    url: "http://localhost/")
    @second_app = App.new(name: Time.now.to_s+"two",
                    description: "Description",
                    url: "http://localhost/")
  end
  subject { @display }
  it { should respond_to(:name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:subscriptions) }
  it { should respond_to(:apps) }
  it { should respond_to(:stagings) }
  it { should respond_to(:staged_apps) }
  it { should respond_to(:staged_app) }
  it { should respond_to(:messages) }
  it { should respond_to(:setup) }

  it { should be_valid }

  describe "setup" do
    before { @setup = @display.build_setup }
    it "should have a thingbroker_url" do
      @setup.should respond_to(:thingbroker_url)
    end
  end


  describe "when name is not present" do
    before { @display.name = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @display.name = "a" * 51 }
    it { should_not be_valid }
  end

 describe "when password is not present" do
    before { @display.password = @display.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @display.password_confirmation = "missmatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @display.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @display.password = @display.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "return value of authenticate method" do
    before { @display.save }
    let(:found_display) { Display.find_by_name(@display.name) }    
    describe "with valid password" do
      it { should == found_display.authenticate(@display.password) }
    end    
    describe "with invalid password" do
      let(:display_for_invalid_password) { found_display.authenticate("invalid") }      
      it { should_not == display_for_invalid_password }
      specify { display_for_invalid_password.should be_false }
    end
  end

  describe "remember_token" do
    before { @display.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "subscriptions" do    
    before do
      @display.save
      @app.save
      @app.subscribe!(@display)
    end
    its(:apps) { should include(@app) }
    describe "and unsubscribing" do 
      before { @app.unsubscribe!(@display) }
      its(:apps) { should_not include(@app) }      
    end
  end

  describe "stagings" do
    before do
      @display.save
      @second_display.save
      @app.save
      @second_app.save
    end
    describe "when there is no staged_app" do
      its(:staged_app) { should be_nil }
    end
    describe "staging two apps in a row" do
      before do
        @display.stage!(@app)
        @display.stage!(@second_app)
      end
      its(:staged_app) { should_not == @app }
      its(:staged_app) { should == @second_app }
    end  
    describe "staging an app in two displays" do
      before do
        @display.stage!(@app)
        @second_display.stage!(@second_app)
      end
      it "should be independent" do
        expect { @display.staged_app.should_not == @second_display.staged_app }
      end 
    end 
  end

end
