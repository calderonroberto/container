require 'spec_helper'
require 'capybara/rails'

describe "Analytics Checkins Pages" do

  subject { page }
  let!(:user) { FactoryGirl.create(:user) }  
  let!(:display) { FactoryGirl.create(:display) }
  before(:all) do  
    3.times { FactoryGirl.create(:user) }
    User.all.each do |u|
      Message.create(from: user.id, message: "message", to: u.id)
      Message.create(from: u.id, message: "message", to: user.id)
    end
    User.all.each do |usr|
      Registration.create(user_id: usr.id, display_id: display.unique_id) #register that this user has visited this thid splay
    end
  end
  after(:all) do
    User.delete_all
    Message.delete_all
  end

  describe "Calling the api" do

    it "should have a user" do
      get "/api/#{display.unique_id}/analytics"
      body = JSON.parse(response.body)
      body[0].should include('user')
      body[0].should include('data')
      body[0].should include('links')
      body[0]['user'].should include('id')
      body[0]['user'].should include('name')
      body[0]['user'].should include('thumbnail_url')
      body[0]['data'].should include('messages_sent')
      body[0]['data'].should include('checkins')
      body[0]['links'][0].should include('user_id')
      body[0]['links'][0].should include('messages_sent')
      body[0]['links'][0].should include('messages_received')
      body[0]['links'][0].should include('reciprocity_ratio')
    end
       
  end

end

