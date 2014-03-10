require 'spec_helper'

describe Note do

  let(:display) { FactoryGirl.create(:display) }
  before { @note = display.notes.build(from: "12345678", message: "message") }   
  
  subject { @note }

  it { should respond_to(:from) }
  it { should respond_to(:message) }
  it { should respond_to(:display_id) }
  it { should respond_to(:display) }
  its(:display) { should == display } 

  it { should be_valid }

  describe "when from is not present" do
    before { @note.from = "" }
    it { should_not be_valid }
  end

  describe "when message is not present" do
    before { @note.message = "" }
    it { should_not be_valid }
  end

  describe "when display_id is not present" do
    before { @note.display_id = "" }
    it { should_not be_valid }
  end

end
