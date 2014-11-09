require 'spec_helper'

describe User do
  #TODO: use Factory girl instead  
  #let(:user) { FactoryGirl.create(:user) }
  #before { @user = user.save }   
  before do
    @user = User.new(  name: Faker::Name.name, 
                       email: Faker::Internet.email,                      
                       uid: Faker::Number.number(6),
	 	       password: Faker::Internet.password,
		       thumbnail_url: Faker::Internet.url,
		       picture_url: Faker::Internet.url,
		       token: Faker::Number.number(30),
		       friends: ["11234", "12345", "123456"])
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:uid) }
  it { should respond_to(:email) }
  it { should respond_to(:provider) }
  it { should respond_to(:password) }
  it { should respond_to(:thumbnail_url) }
  it { should respond_to(:picture_url) }
  it { should respond_to(:token) }
  it { should respond_to(:friends) }
  it { should respond_to(:checkins) }

  it { should be_valid }

end
