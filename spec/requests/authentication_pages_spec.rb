require 'spec_helper'
require 'capybara/rails'

describe "AuthenticationPages" do
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    it { should have_selector('h2',    text: 'Sign in') }
  end  
  
  describe "signin" do
    before {visit signin_path }
    describe "with invalid information" do
      before { click_button "Sign in" } 
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      describe "after visiting another page" do
        before { visit root_url }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    describe "with valid information" do
      let(:display) { FactoryGirl.create(:display) }
      before do
        fill_in "Name",  with: display.name
        fill_in "Password", with: display.password
        click_button "Sign in"
      end
      it { should have_selector('iframe.appcontainer') }
    end
  end

end
