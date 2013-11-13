require 'spec_helper'
require 'capybara/rails'

describe "StaticPages" do

  subject { page }

  describe "Welcome Page" do
    before { visit welcome_path }
    it { should have_selector('p', text: 'MAGIC Web-App Container - Cherry Version.') }
  end

  describe "Home Page" do
    let(:display) { FactoryGirl.create(:display) }
    before(:all) { 4.times { FactoryGirl.create(:app) } }
    after(:all) { App.delete_all }
    before do
      App.all.each do |app|
        app.subscribe!(display)
      end
    end 
    describe "for non-signed-in displays" do
      describe "visiting the home page" do
        before { visit home_url }
        it { should have_selector('h2', text: 'Sign in') }
      end
      describe "for signed-in displays", :js => true do
        before do 
          sign_in display 
          #wait_for_page_to_load(5) #removed this as it seems method doesn't exist (using below instead)
          wait_until do           
             page.has_selector?('iframe.appcontainer')
          end
          
        end

        describe "after signin in" do
          it "should render home static page" do

            page.should have_selector('iframe.appcontainer')
            page.should have_selector('title', text: 'MAGIC Container')
            page.should have_selector('div.messageboard')
            page.should have_selector('div.qrcodeurl', text: "mobile/#{display.id}")
            page.should have_selector('div.appmenu')
          end
          it "should list subscribed apps" do
            #puts Display.find(display.id).apps.inspect
            Display.find(display.id).apps.each do |app|
              page.should have_xpath("//img[@src='#{app.thumbnail_url}']")   
              page.should have_xpath("//img[@id='#{app.id}']")                 
              #page.should have_xpath("//class[@id='appthumbnail']")                 
            end
          end
        end
      end
    end

    #describe "clicking on application" do #, :js => true
    #  before do 
    #    sign_in display
    #  end
    #  it "should stage application" do
    #    Display.find(display.id).apps.each do |app|
    #      puts app.id
    #      click_link("#{app.id}")
    #      wait_until(10) { page.should have_selector("iframe.appcontainer#"+"#{app.id}") }        
    #      wait_until(10) { page.should have_xpath("//a[@class='selected']") }
    #    end
    #  end
    #end 
  end

end
