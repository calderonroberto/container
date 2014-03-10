require 'spec_helper'
require 'capybara/rails'

describe "NotesPages" do

  subject { page }

  let!(:display) { FactoryGirl.create(:display) }
  let!(:user) { FactoryGirl.create(:user) }
  before(:all) do
    3.times { FactoryGirl.create(:app) }
    App.all.each do |app|
      app.subscribe!(display)
    end
  end
  after(:all) { App.delete_all }

  describe "without signing in" do
    before { visit notes_new_path(display.unique_id) }
    it { should have_link('Sign in using Facebook', href: "/users/auth/facebook") }
  end

  describe "creating a note" do
    before{      
      sign_in_user(display, user)
      visit notes_new_path(display.unique_id)
    }
    it "should have all elements" do
      visit notes_new_path(display.unique_id)
      page.should have_link('Apps', href: "/mobile/#{display.unique_id}" )
      page.should have_link('Note', href: "/notes/new/#{display.unique_id}")
      page.should have_link('People', href: "/people/#{display.unique_id}")
      page.should have_selector(:xpath, "//img[@src='#{user.thumbnail_url}']")
      page.should have_selector('h2', text: "Send a Note")
      page.should have_selector(:xpath, "//input[@type='hidden' and @value='#{display.unique_id}']")
    end 
    it "should not create with invalid information" do
      expect { click_button "Send" }.should_not change(Note, :count)
    end
    it "should have correct error messages" do
      click_button "Send"
      page.should have_link('Apps', href: "/mobile/#{display.unique_id}" ) 
      page.should have_link('People', href: "/people/#{display.unique_id}") 
      page.should have_content('error') 
    end
    it "should create with valid information" do
      fill_in "Message", with: "Hello world"
      expect { click_button "Send" }.should change(Note, :count).by(1)     
    end    
  end
 

end
