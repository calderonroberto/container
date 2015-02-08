require 'spec_helper'

describe Registration do
  
   pending "Pending Registration rspec tests"

   let (:display){ FactoryGirl.create(:display) }
   let (:user) { FactoryGirl.create(:user) } 
  

   describe "creating a registration with a user" do
      before do
         @registration = Registration.new(user_id: user.id, display_id: display.id)
         @registration.save!
      end 
 
      it "should attach registration to user" do
         #pending here
      end
 
   end
  
end
