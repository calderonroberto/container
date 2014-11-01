require 'spec_helper'

#TODO: working on this
describe Favour do

  let(:user) { FactoryGirl.create(:user) }
  let(:seconduser) { FactoryGirl.create(:user) }

  before(:all) do
    @favour = Favour.new(from_id: user.id, to_id: seconduser.id)
  end
  after(:all) { 
	User.delete_all
	Favour.delete_all 
  }
  
  subject { @favour }

  it { should respond_to(:from_id) }
  it { should respond_to(:to_id) }
  it { should respond_to(:reciprocated) }
  
  it { should be_valid }
 
  describe "when from_id is not present" do
    before { @favour.from_id = "" }
    it { should_not be_valid }
  end

  describe "when to_id is not present" do
    before { @favour.to_id = "" }
    it { should_not be_valid }
  end


end
