require 'spec_helper'
require 'capybara/rails'

describe "App pages" do

  subject { page }
  let(:display) { FactoryGirl.create(:display) }
  let(:new_app) { FactoryGirl.create(:app) }

  describe "when not signed in" do 
    before { visit new_app_path } 
    it { should have_selector('h2', text: 'Sign in') }
  end

  describe "when signed in" do
    before do
      sign_in display
      visit new_app_path
    end
    it { should have_link ('Sign out') }
    it { should have_link ('Apps') }
  end
  
  describe "creating an app" do
    before do
      sign_in display
      visit new_app_path
    end
    describe "with invalid information" do
      it "should not create an app" do
        expect { click_button "Create" }.should_not change(App, :count)
      end
      describe "error messages" do
        before { click_button "Create" }
        it { should have_content('error') }
      end
    end
    describe "with valid information" do
      before do
        fill_in "app_name", with: new_app.name + Time.now.getutc.to_i.to_s
        fill_in "app_description", with: new_app.description
        fill_in "app_url", with: new_app.url
        fill_in "app_mobile_url", with: new_app.url
      end
      it "should be able to create an app" do
        expect { click_button "create" }.should change(App, :count).by(1)
      end
    end
  end

  describe "modifying an app" do
    before do
      sign_in display
      @app = App.new(  name: "Application" + Time.now.getutc.to_i.to_s, 
                       description: "Application description",
                       url: "http://localhost/",
                       thumbnail_url: "http://localhost/")
      @app.save
      #puts @app.inspect
      visit edit_app_path(@app)
    end
    describe "page" do
      it { should have_selector('h2', text: 'Modify App') }
    end
    describe "with invalid information" do
      before do
        fill_in "Name", with: "a" * 51
        fill_in "Url", with: "wrong url"
        fill_in "app_mobile_url", with: "wrong url"
      end
      before { click_button "Save" }
      it { should have_content('error') }
    end
    describe "with valid information" do
      before do
        fill_in "Name", with: "New awesome name"
        fill_in "Description", with: "New awesome description"
        fill_in "Url", with: "http://google.com/awesome.html"
        fill_in "app_mobile_url", with: "http://google.com/awesome.html"
        click_button "Save"
      end
      it { should have_selector('div.alert.alert-success') }
    end
  end

end
