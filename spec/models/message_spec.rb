require 'spec_helper'

describe Message do

  let(:display) { FactoryGirl.create(:display) }

  before(:all) do
    2.times { FactoryGirl.create(:user) }
    first_user = User.first
    second_user = User.last
    @message = Message.new(from: first_user.id, message: "message", to: second_user.id)
  end
  after(:all) { User.delete_all }

  subject { @message }

  it { should respond_to(:from) }
  it { should respond_to(:message) }
  it { should respond_to(:to) }
  
  it { should be_valid }
 
  describe "when message is not present" do
    before { @message.message = "" }
    it { should_not be_valid }
  end

  describe "when to is not present" do
    before { @message.to = "" }
    it { should_not be_valid }
  end  

end
