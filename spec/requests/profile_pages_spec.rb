require 'spec_helper'
require 'capybara/rails'

#TODO: working on this one


describe "ProfilePages" do

  subject { page }
  let!(:display) { FactoryGirl.create(:display) }
  let!(:user) { FactoryGirl.create(:user) }  
  before(:all) do
    3.times { FactoryGirl.create(:app) }
    App.all.each do |app|
      app.subscribe!(display)
    end
  end
  after(:all) do
    App.delete_all 
    User.delete_all
    Message.delete_all
  end
  
  describe "without signing in" do
    before {
        visit "/mobile/#{display.unique_id}" #set cookies by visiting url first (otherwise it throws an error when logging which display was visited
        visit "/profile"
    }
    it { should have_link('Sign in using Facebook', href: "/users/auth/facebook") }
  end

  describe "visiting signed in" do
    
    before{
      sign_in_user(display, user)
      visit "/profile"
    }

    it { should_not have_link('Sign in with Facebook', href: "/users/auth/facebook") }

    it "should have navigation" do    
      page.should have_link('Apps', href: "/mobile/#{display.unique_id}")
      page.should have_link('Note', href: "/notes/new/#{display.unique_id}")
      page.should have_link('Profile', href: "/profile")
      page.should have_link('People', href: "/people/#{display.unique_id}")
      page.should have_selector(:xpath, "//img[@src='#{user.thumbnail_url}']")
    end
    
    #it "should list user info" do
    #   page.should have_selector(:xpath, "//img[@src='#{user.picture_url}']")
    #end

    it "should list checkins" do
       page.should have_xpath("//div[@class='checkins_count']")
    end 

    it "should have a checkin button" do
       page.should have_css('div.checkin_form')
    end

    it "should have a list of gifts" do
      page.should have_xpath("//div[@class='profile-giftlist']")
    end


  end

end

