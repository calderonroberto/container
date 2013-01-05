require 'spec_helper'
require 'capybara/rails'

describe "DisplayPages" do
  subject { page }

  let(:new_display) { FactoryGirl.create(:display) } 

  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h2', text: 'Create a Display') }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create" }
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(Display, :count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Name", with: new_display.name
        fill_in "Password", with: new_display.password
        fill_in "Confirmation", with: new_display.password_confirmation
      end
      it "should create a user" do
        expect { click_button submit }.to change(Display, :count).by(1)
      end
    end
  end

end

