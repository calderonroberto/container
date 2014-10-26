require 'spec_helper'
require 'capybara/rails'

describe "Setup pages" do

  subject { page }
  let(:display) { FactoryGirl.create(:display) }
  #let(:new_app) { FactoryGirl.create(:app) }

  describe "when not signed in" do
    before { visit edit_setup_path(display.setup) } 
    it { should have_selector('h2', text: 'Sign in') }
  end

  describe "when signed in" do
    before do
      sign_in display
      visit edit_setup_path(display.setup)
    end
    it { should have_link ('Sign out') }
    it { should have_link ('Apps') }
    it { should have_xpath("//input[@id='setup_thingbroker_url']") }           
    it { should have_xpath("//input[@id='setup_interact_instructions']") }
    it { should have_xpath("//select[@id='setup_experimental_setup']") }
    it { should have_xpath("//input[@id='is_global']") }                 
  end

  describe "modifying a setup" do
    before do
      sign_in display
      visit edit_setup_path(display.setup)
    end
    describe "page" do
      it { should have_selector('h2', text: 'Modify Container Setup') }
    end
    describe "with invalid information" do
      before do
        fill_in "setup_thingbroker_url", with: "wrong url"
      end
      before { click_button "Save" }
      it { should have_content('error') }
    end
    describe "with valid information" do
      before do
        fill_in "setup_thingbroker_url", with: "http://google.com:8080"
        click_button "Save"
      end
      it { should have_selector('div.alert.alert-success') }
    end
  end

end
