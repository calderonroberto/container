require 'spec_helper'

describe Checkin do

  let(:display) { FactoryGirl.create(:display) }
  let(:user) { FactoryGirl.create(:user) }

  before(:all) do
    @checkin = user.checkins.build(display_id: display.id)
  end
  after(:all) { User.delete_all }

  subject { @checkin }

  it { should respond_to(:display_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) } #testing that checkin.user exists
  its(:user) { should == user } #testing that checkin.user exists
  
  it { should be_valid }
 
  describe "when display_id is not present" do
    before { @checkin.display_id = "" }
    it { should_not be_valid }
  end

end
