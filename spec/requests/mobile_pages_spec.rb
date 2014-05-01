require 'spec_helper'
require 'capybara/rails'

describe "Mobile pages" do

  subject { page }
  
  let!(:display) { FactoryGirl.create(:display) }
  let!(:user) { FactoryGirl.create(:user) }
  before(:all) do
    9.times { FactoryGirl.create(:app) }
    App.all.each do |app|
      app.subscribe!(display)
    end
  end
  after(:all) { App.delete_all }

  describe "visiting mobile page" do
    before { visit mobile_path(display.unique_id) }
    it { should have_link('Sign in using Facebook', href: "/users/auth/facebook") }   
    it { should have_selector("div.signin-intro") }
    it { should have_selector("div.signin-intro-people") }
    it { should have_selector("div.signin-intro-text") }
  end

  describe "visiting mobile page signedin" do

    before { 
      sign_in_user(display, user)
    }

    #TODO: check this later
    #it { should display_flash_message('Successfully authenticated from Facebook account.') }
    
    it { should have_selector(:xpath, "//img[@src='#{user.thumbnail_url}']") }
    it { should have_link('Apps', href: "/mobile/#{display.unique_id}") }
    it { should have_link('Note', href: "/notes/new/#{display.unique_id}") }
    it { should have_link('People', href: "/people/#{display.unique_id}") }
    it { should have_link('Signout', href: "/signoutuser") }

    it "should list subscribed apps leading to appropriate containers" do
      Display.find(display.id).apps.each do |app|
        page.should have_link("#{app.id}")  
      end
    end

    it "visiting each app should lead to proper containers" do
      Display.find(display.id).apps.each do |app|
	click_link('Apps')
        click_link("#{app.id}")
        page.should have_selector("iframe.mobileappcontainer#"+"#{app.id}") 
        page.should have_xpath("//img[@src='#{user.thumbnail_url}']")                      
        page.should have_link('Apps', href: "/mobile/#{display.unique_id}" )
        page.should have_link('Note', href: "/notes/new/#{display.unique_id}")      
	page.should have_link('People', href: "/people/#{display.unique_id}")
	click_link('Apps')
      end
    end
  end
  
  
end
