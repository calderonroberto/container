require 'spec_helper'
require 'capybara/rails'

describe CheckinsController do

  let!(:display) { FactoryGirl.create(:display) }
  let!(:user) { FactoryGirl.create(:user) }
  before(:all) {  FactoryGirl.create(:user, :email => "anonymous@email.com") }
  after(:all) { User.delete_all }
 

  describe "creating a checkin with Ajax" do
    before { sign_in_user(display, user) }
    it "should increment chekins" do
      expect do
        xhr :post, :create, checkin: { display_id: display.id, user_id: user.id }
      end.should change(Checkin, :count).by(1)
    end 
    it "should respond with success" do
      xhr :post, :create, checkin: { display_id: display.id, user_id: user.id }
      response.should be_success
    end
  end

end

