require 'spec_helper'

describe Setup do
 
  let(:display) { FactoryGirl.create(:display) }
  before { @setup = display.build_setup }   
  
  subject { @setup }
 
  it { should respond_to(:thingbroker_url) }

  describe "it should have a default url" do
    it { should be_valid }
  end

  describe "when thingbroker_url is valid" do
    before { @setup.thingbroker_url = "http://localhost:8080/thingbroker" }
    it { should be_valid }
  end

  describe "when thingbroker_url is not present" do
    before { @setup.thingbroker_url = "" }
    it { should_not be_valid }
  end
  
  describe "when thingbroker_url is invalid" do
    it "should be invalid" do
      addresses = %w[url url.com htp://url htp://url.com ]
      addresses.each do |invalid_address|
        @setup.thingbroker_url = invalid_address
        @setup.should_not be_valid
      end
    end
  end

end

