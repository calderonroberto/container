require 'spec_helper'
require 'capybara/rails'

describe "Admin pages" do

  subject { page }
  let(:display) { FactoryGirl.create(:display) }
  before(:all) { 32.times { FactoryGirl.create(:app) } }
  after(:all) { App.delete_all }
  
  describe "visiting admin page" do
    describe "when not signed in" do
      before { visit admin_path }
      it { should have_selector('h2', text: 'Sign in') }
    end
    describe "when signed in" do
      before { sign_in display }
      before { visit admin_path }
      it { should have_selector('title', text: 'MAGIC Container | Administration') }
      it { should have_link ('Apps') }
      it { should have_link('Create App') }
      it { should have_link('Sign out') }
      it { should have_link('Manage Workers') }
      it { should have_link('Container Setup') }
      it { should have_selector('div.pagination') }
      it "should list each app" do
        App.paginate(page: 1, per_page: 10).each do |app|
          page.should have_selector('li', text: app.name)
          page.should have_selector('span.description')
          page.should have_selector('span.url')
          page.should have_selector('span.mobile_url')
          page.should have_link('Modify')
          page.should have_link('Delete')
          page.should have_selector('div.subscribe_form')
        end    
      end
      it "should be able to delete an App" do
        expect { click_link('Delete') }.to change(App, :count).by(-1)
      end       
    end
  end

end
