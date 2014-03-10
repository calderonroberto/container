require 'spec_helper'
require 'capybara/rails'

describe "StaticPagesHome" do

  subject { page }

  let!(:display) { FactoryGirl.create(:display) }
  before(:all) { 3.times { FactoryGirl.create(:app) } }
  after(:all) { App.delete_all }

  describe "not signed in" do
    before { visit home_url }
    it { should have_selector('h2', text: 'Sign in') }
  end  
  
  describe "for signed-in displays", :js => true do
    before do 
      sign_in display 
      wait_until do           
         page.has_selector?('iframe.appcontainer')
      end          
      visit admin_path
      App.all.each do |app|
        click_button("subscribe-#{app.id}")
      end
      visit home_path
    end
    it "should render home static page" do
      page.should have_selector('iframe.appcontainer')
      page.should have_selector('div.messageboard')
      page.should have_selector('div.qrcodeurl')
      page.should have_selector('div.appmenu')
    end
    it "should list subscribed apps" do
      Display.find(display.id).apps.each do |app|              
        page.should have_xpath("//img[@src='#{app.thumbnail_url}']")
        page.should have_xpath("//img[@id='#{app.id}']")                 
        page.should have_xpath("//class[@id='appthumbnail']")                 
      end
    end
  end 

end
