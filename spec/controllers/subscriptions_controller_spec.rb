require 'spec_helper'
require 'capybara/rails'

describe SubscriptionsController do

  let(:display) { FactoryGirl.create(:display) }
  let(:an_app) { FactoryGirl.create(:app) }
  let(:a_second_app) { FactoryGirl.create(:app) }
  before { sign_in display }

  describe "creating a subscription with Ajax" do
    it "should increment the Subscription count" do
      expect do
        xhr :post, :create, subscription: { app_id: an_app.id }
      end.should change(Subscription, :count).by(1)
    end 
    it "should respond with success" do
      xhr :post, :create, subscription: { app_id: an_app.id }
      response.should be_success
    end
  end

  describe "destroying a subscription with Ajax" do
    before { an_app.subscribe!(display) }
    let(:subscription) { display.subscriptions.find_by_app_id(an_app.id) }
    it "should decrement the Subscription count" do
      expect do
        xhr :delete, :destroy, id: subscription.id
      end.should change(Subscription, :count).by(-1)
    end
    it "should respond with success" do
       xhr :delete, :destroy, id: subscription.id
       response.should be_success
    end
  end

end
