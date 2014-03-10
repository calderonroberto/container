require 'spec_helper'
require 'capybara/rails'

describe "State pages" do

  subject { page }
  let(:display) { FactoryGirl.create(:display) }
  let(:new_app) { FactoryGirl.create(:app) }

  describe "Calling the api" do
    before do      
      new_app.subscribe!(display)
      display.stage!(new_app)    
      5.times { display.notes.build(from: "someone", message: "message").save }
      sign_in display
    end

    it "should be successfully parsed" do
      get api_state_url
      response.should be_success
      body = JSON.parse(response.body)
    end

    it "should contain all objects" do   
      get api_state_url
      body = JSON.parse(response.body)   
      body.should include('display')
      body.should include('apps')
      body.should include('notes')
      body.should include('staged_app')
      body.should include('setup')
    end
       
    it "a setup object" do
      get api_state_url
      body = JSON.parse(response.body)
      body['setup'].should include('thingbroker_url')
    end
 
    it "a display object" do      
      get api_state_url
      body = JSON.parse(response.body)   
      body['display'].should include('id')
      body['display'].should include('name')
      body['display'].should_not include('password_digest')
    end
     
    it "an app object" do      
      get api_state_url
      body = JSON.parse(response.body)   
      body['apps'][0].should include('id')
      body['apps'][0].should include('name')
      body['apps'][0].should include('description')
      body['apps'][0].should include('url')
      body['apps'][0].should include('mobile_url')
      body['apps'][0].should include('thumbnail_url')
    end
      
    it "a message object" do    
      get api_state_url
      body = JSON.parse(response.body)
      body['notes'][0].should include('from')
      body['notes'][0].should include('message')
      body['notes'].length.should be < 5
    end
       
    it "app_staged object" do      
      get api_state_url
      body = JSON.parse(response.body)
      body['staged_app'].should include('id')
      body['staged_app'].should include('name')
      body['staged_app'].should include('description')
      body['staged_app'].should include('url')
      body['staged_app'].should include('mobile_url')
      body['staged_app'].should include('thumbnail_url')
    end
       
  end

end

