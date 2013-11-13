require 'spec_helper'

describe StagingsController do

  let(:display) { FactoryGirl.create(:display) }
  let(:an_app) { FactoryGirl.create(:app) }
  before { sign_in display }

  describe "creating a staging with Ajax" do
    it "should increment change the staging" do
      expect do
        xhr :post, :create, staging: { app_id: an_app.id }
      end.should change(Staging, :count).by(1)
    end 
    it "should respond with success" do
      xhr :post, :create, staging: { app_id: an_app.id }
      response.should be_success
    end
  end


end
