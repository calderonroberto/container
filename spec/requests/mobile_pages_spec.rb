require 'spec_helper'
require 'capybara/rails'

describe "Mobile pages" do

  subject { page }
  
  let(:display) { FactoryGirl.create(:display) }
  before(:all) { 9.times { FactoryGirl.create(:app) } }
  after(:all) { App.delete_all }
  before do
    App.all.each do |app|
      app.subscribe!(display)
    end
  end 

  describe "visiting mobile page" do
    before { visit mobile_path(display.id) }
    it { should have_link('Apps', href: "/mobile/#{display.id}") }
    it { should have_link('Message', href: "/messages/new/#{display.id}") }
    it "should list subscribed apps leading to appropriate containers" do
      Display.find(display.id).apps.each do |app|
        visit mobile_path(display.id)
        page.should have_link("#{app.id}")
        page.should have_xpath("//img[@src='#{app.thumbnail_url}']")                 
      end
    end
    it "and visiting each app should lead to proper containers" do
      Display.find(display.id).apps.each do |app|
        visit mobile_path(display.id)
        click_link("#{app.id}")
        page.should have_selector("iframe.mobileappcontainer#"+"#{app.id}")        
        page.should have_link('Apps', href: "/mobile/#{display.id}" )
        page.should have_link('Message', href: "/messages/new/#{display.id}")
      end
    end
  end
  
  
end
