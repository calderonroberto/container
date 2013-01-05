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
      5.times { display.messages.build(from: "someone", message: "message").save }
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
      body.should include('messages')
      body.should include('staged_app')
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
      body['apps'][0].should include('thumbnail_url')
    end
      
    it "a message object" do    
      get api_state_url
      body = JSON.parse(response.body)
      body['messages'][0].should include('from')
      body['messages'][0].should include('message')
      body['messages'].length.should be < 5
    end
       
    it "app_staged object" do      
      get api_state_url
      body = JSON.parse(response.body)
      body['staged_app'].should include('id')
      body['staged_app'].should include('name')
      body['staged_app'].should include('description')
      body['staged_app'].should include('url')
      body['staged_app'].should include('thumbnail_url')
    end
       
  end

end

