require 'spec_helper'
require 'capybara/rails'

describe "Message pages" do

  subject { page }
  let(:display) { FactoryGirl.create(:display) }

  before do 
    visit mobile_path(display.id)
  end
  describe "should have header and text" do 
    it { should have_link('Apps', href: "/mobile/#{display.id}" ) }
    it { should have_link('Message', href: "/messages/new/#{display.id}") }
  end  
  describe "creating a message " do
    before { click_link('Message') }
    it { should have_selector('h2', text: "Send a message") }
    describe "with invalid information" do
      it "should not create an app" do
        expect { click_button "Send" }.should_not change(Message, :count)
      end
      describe "error messages" do
        before { click_button "Send" }
        it { should have_link('Apps', href: "/mobile/#{display.id}" ) }
        it { should have_link('Message', href: "/messages/new/#{display.id}") }
        it { should have_content('error') }
      end
    end
    describe "with valid information" do
      before do
        fill_in "From", with: "Anonymous"
        fill_in "Message", with: "Hello world"
      end
      it "should be able to create a message and redirect back to container" do
        expect { click_button "Send" }.should change(Message, :count).by(1)
      end
    end
  end

end
