class User < ActiveRecord::Base

  # http://amberonrails.com/storing-arrays-in-a-database-field-w-rails-activerecord/
  serialize :friends

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :uid, :name, :provider, :password, :token, :thumbnail_url, :picture_url, :friends

  has_many :checkins, dependent: :destroy #making sure that microposts are destroyed when a user is

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
   #user = User.where(:provider => auth.provider, :uid => auth.uid).first #TODO: remove after checking it works
    user = User.where(:provider => auth["provider"], :uid => auth["uid"]).first
    unless user
      user = User.create(name:auth["extra"]["raw_info"]["name"],
                         provider:auth["provider"],
                         uid:auth["uid"],
                         email:auth["extra"]["raw_info"]["email"],
                         password:Devise.friendly_token[0,20],
                         token:auth["credentials"]["token"],
                         thumbnail_url:"http://graph.facebook.com/#{auth["uid"]}/picture?type=small",
                         picture_url:"http://graph.facebook.com/#{auth["uid"]}/picture?type=large",

                         )
      unless user.nil?
        Resque.enqueue(FacebookParser, user.uid) #we're leaving this to a reske worker as it might fail
      end
    end
    user #return created user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def checkin!(display) #bang tells rails that the method should raise an exception if it fails
    checkins.create!(display_id: display.id)
  end

end
