require 'spec_helper'
require 'capybara/rails'

describe "UsersPages" do

  subject { page }
  let!(:display) { FactoryGirl.create(:display) }
  let!(:user) { FactoryGirl.create(:user) }
  before(:all) do
    3.times { FactoryGirl.create(:user) }
    3.times { FactoryGirl.create(:app) }
    App.all.each do |app|
      app.subscribe!(display)
    end
    User.all.each do |usr|
      Registration.create(user_id: usr.id, display_id: display.unique_id) #register that this user has visited this thid splay
    end

  end
  after(:all) do
    App.delete_all 
    User.delete_all
  end

  describe "without signing in" do
    before { visit people_path(display.unique_id) }
    it { should have_link('Sign in using Facebook', href: "/users/auth/facebook") }
  end

  describe "visiting signed in" do
    before{
      sign_in_user(display, user)
      visit people_path(display.unique_id)
    }
    it "should have navigation bar" do
      page.should have_link('Apps', href: "/mobile/#{display.unique_id}" )
      page.should have_link('Note', href: "/notes/new/#{display.unique_id}")
      page.should have_link('People', href: "/people/#{display.unique_id}")
      page.should have_selector(:xpath, "//img[@src='#{user.thumbnail_url}']")
    end
    it "should list all users" do

      #User.all.each do |user|
      User.where('id != ?', user.id).each do |u|
        page.should have_xpath("//div[@id='#{u.id}']")
        page.should have_xpath("//img[@id='#{u.id}']")
        page.should have_xpath("//div[@class='checkins_count']")
        page.should have_link(u.name)
      end
    end
  end


end
