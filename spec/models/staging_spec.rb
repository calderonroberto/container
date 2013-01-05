require 'spec_helper'
require 'capybara/rails'

describe Staging do

  let(:display) { FactoryGirl.create(:display) }
  let(:app) { FactoryGirl.create(:app) }
  let(:staging) { display.stagings.build(app_id: app.id) }

  subject { staging }
  it { should be_valid }    

  describe "accessible attributes" do
    it "should not allow access to display_id" do
      expect do
        Staging.new(display_id: display.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when display id is not present" do
    before { staging.display_id = nil }
    it { should_not be_valid }
  end

  describe "when app id is not present" do
    before { staging.app_id = nil }
    it { should_not be_valid }
  end

  describe "deleting a staging" do
    before do
      @staging = display.stagings.build(app_id: app.id)
    end
    it "should be nil" do
      @staging.save!
      @staging.destroy
      Staging.find_by_id(staging.id).should be_nil
    end
  end

end
