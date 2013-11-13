require 'spec_helper'
require 'capybara/rails'

describe Subscription do

  let(:display) { FactoryGirl.create(:display) }
  let(:app) { FactoryGirl.create(:app) }
  let(:subscription) { display.subscriptions.build(app_id: app.id) }

  subject { subscription }
  it { should be_valid }    

  describe "when display id is not present" do
    before { subscription.display_id = nil }
    it { should_not be_valid }
  end

  describe "when app id is not present" do
    before { subscription.app_id = nil }
    it { should_not be_valid }
  end

  describe "deleting a subscription" do
    before do
      @subscription = Subscription.new(display_id: display.id, app_id: app.id)
      @subscription.save!
    end
    it "should be nil" do
      @subscription.destroy
      Subscription.find_by_id(subscription.id).should be_nil
    end
    it "should not delete display" do
      @subscription.destroy
      Display.find_by_id(display.id).should_not be_nil
    end
    it "should not delete app" do
      @subscription.destroy
      App.find_by_id(app.id).should_not be_nil
    end
  end

end
