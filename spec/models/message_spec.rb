require 'spec_helper'

describe Message do

  let(:display) { FactoryGirl.create(:display) }
  before { @message = display.messages.build(from: "Someone", message: "message") }   
  
  subject { @message }

  it { should respond_to(:from) }
  it { should respond_to(:message) }
  it { should respond_to(:display_id) }
  it { should respond_to(:display) }
  its(:display) { should == display } 

  it { should be_valid }

  describe "when from is not present" do
    before { @message.from = "" }
    it { should_not be_valid }
  end

  describe "when message is not present" do
    before { @message.message = "" }
    it { should_not be_valid }
  end

  describe "when display_id is not present" do
    before { @message.display_id = "" }
    it { should_not be_valid }
  end

end
