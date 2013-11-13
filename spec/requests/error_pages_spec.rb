require 'spec_helper'
require 'capybara/rails'

describe "ErrorPages" do
 
  subject { page }

  describe "Visiting an unexistent route" do
    before { visit '/public/404.html' }
    it { should have_selector('p', text: 'You may have mistyped the address or the page may have moved.') }
    it { should have_xpath("//img[@src='/assets/404.gif']") }
  end



end
