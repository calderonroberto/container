require 'spec_helper'

#TODO: working on this
describe Gift do

  let(:user) { FactoryGirl.create(:user) }
  let(:seconduser) { FactoryGirl.create(:user) }

  before(:all) do
    @gift = user.gifts.build(from_id: seconduser.id)
  end
  after(:all) { User.delete_all }

  subject { @gift }

  it { should respond_to(:user_id) }
  it { should respond_to(:from_id) }
  it { should respond_to(:gift_type) }
  it { should respond_to(:user) } #testing that gift.user exists
  its(:user) { should == user } #testing that gift.user exists
  
  it { should be_valid }
 
  describe "when from_id is not present" do
    before { @gift.from_id = "" }
    it { should_not be_valid }
  end

  describe "when type is not present" do
    before { @gift.gift_type = "" }
    it { should_not be_valid }
  end


end
