require 'spec_helper'
require 'capybara/rails'

describe "StaticPagesHome" do

  subject { page }

  let!(:display) { FactoryGirl.create(:display) }
  before(:all) { 3.times { FactoryGirl.create(:app) } }
  after(:all) { App.delete_all }

  describe "Welcome Page" do
    before { visit welcome_path }
    it { should have_selector('p', text: 'MAGIC Web-App Container - Cherry Version.') }
  end

end
