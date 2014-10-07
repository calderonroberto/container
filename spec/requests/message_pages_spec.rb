require 'spec_helper'
require 'capybara/rails'

describe "MessagePages" do

  subject { page }
  let!(:display) { FactoryGirl.create(:display) }
  let!(:user) { FactoryGirl.create(:user) }  
  before(:all) do
    3.times { FactoryGirl.create(:user) }
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

    before { visit "/messages/new/#{display.unique_id}?user_id=#{User.last.id}" }
    it { should have_link('Sign in using Facebook', href: "/users/auth/facebook") }
  end

  describe "visiting signed in" do

    
    before{
      sign_in_user(display, user)
      visit "/messages/new/#{display.unique_id}?user_id=#{User.last.id}"
    }

    it { should_not have_link('Sign in with Facebook', href: "/users/auth/facebook") }

    it "should have navigation" do    
      page.should have_link('Apps', href: "/mobile/#{display.unique_id}")
      page.should have_link('Note', href: "/notes/new/#{display.unique_id}")
      page.should have_link('People', href: "/people/#{display.unique_id}")
      page.should have_selector(:xpath, "//img[@src='#{user.thumbnail_url}']")
    end
    
    it "should list user info" do
      page.should have_selector(:xpath, "//img[@src='#{User.last.picture_url}']")
    end
 
    it "should have a form to submit a message" do
      page.should have_selector('h3', text: "Message #{User.last.name}")
      page.should have_selector(:xpath, "//input[@type='hidden' and @id='message_display_id' and @value='#{display.unique_id}']")
      page.should have_selector(:xpath, "//input[@type='hidden' and @id='message_from_id' and @value='#{user.id}']")
      page.should have_selector(:xpath, "//input[@type='hidden' and @id='message_to_id' and @value='#{User.last.id}']")
     #TODO: should have message box
    end

    it "should have correct error messages" do
      click_button "Send"
      page.should have_selector(:xpath, "//img[@src='#{user.thumbnail_url}']")
      page.should have_link('Apps', href: "/mobile/#{display.unique_id}")
      page.should have_link('Note', href: "/notes/new/#{display.unique_id}")
      page.should have_link('People', href: "/people/#{display.unique_id}")
      page.should have_content('error') 
    end

    it "should submit a message" do
      fill_in "Message", with: "Hi there"
      expect { click_button "Send" }.should change(Message, :count).by(1)
      page.should have_selector("div", text: "Hi there")
    end    
  end

end

