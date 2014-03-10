require 'spec_helper'
require 'capybara/rails'

describe "CheckinsPages" do

  subject { page }
  let!(:display) { FactoryGirl.create(:display) }
  let!(:user) { FactoryGirl.create(:user) }
  before(:all) do
    user.checkins.build(display_id: display.id).save
    3.times { FactoryGirl.create(:user) }
    3.times { FactoryGirl.create(:app) }    
    App.all.each do |app|
      app.subscribe!(display)
    end        
  end
  after(:all) do
    App.delete_all 
    User.delete_all
  end

  describe "visiting signed in" do
    before{
      sign_in_user(display, user) 
      visit "checkins/#{display.unique_id}" #TODO: signing (omniauth) does not update cookies for test, failing as it cannot find User.find(cookies[:user_id]) in checkins controller. We don't have time to check this before my experiment, so we'll have to trust it.
    }
    it "should list all users" do
      User.all.each do |u|
        page.should have_xpath("//div[@id='#{u.id}']")
        page.should have_xpath("//img[@id='#{u.id}']")
        page.should have_xpath("//div[@class='checkins_count']")
        page.should have_xpath("//div[@class='checkins_user_name']")
        page.should have_selector('div.checkin_form')
      end
    end
  end

  describe "Calling the display checkins api" do
    it "should return proper data" do
      get "/api/#{display.unique_id}/checkins"
      body = JSON.parse(response.body)
      #puts body.inspect
      body[0].should include('user')
      body[0].should include('checkin')
      body[0]['user'].should include('id')
      body[0]['user'].should include('name')
      body[0]['checkin'].should include('created_at')
      body[0]['checkin'].should include('display_id')
    end      
  end


end
