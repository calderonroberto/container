class User < ActiveRecord::Base

  # http://amberonrails.com/storing-arrays-in-a-database-field-w-rails-activerecord/
  serialize :friends

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :uid, :name, :provider, :password, :token, :thumbnail_url, :picture_url, :friends, :test_group, :registrations

  has_many :checkins, dependent: :destroy #making sure that checkins are destroyed when a user is
  has_many :gifts, dependent: :destroy #making sure  that gifts are destroyed when a user is
  has_many :registrations, dependent: :destroy #making sure that registrations are destroyed when a user is

  def score(display, time_from, time_to)
    score = Hash["score" => 0, "checkins" => 0, "favours" => 0]
    checkins = Checkin.where("display_id = ? AND user_id = ? AND created_at >= ? AND created_at <= ?", display.id, self.id, time_from, time_to).count
    favours= Favour.where("(to_id = ? OR from_id = ?) AND reciprocated =? AND created_at >= ? AND created_at <= ?", self.id, self.id, true, time_from, time_to).count
    
    score["checkins"] = checkins
    score["favours"] = favours

    if display.setup.experimental_setup == 0
       #When individual: Checkins + favours resolved
       score["pool_points"] = 0 
       score["score"] = checkins+ favours
    elsif display.setup.experimental_setup == 1
       #When communal: (Checkins/N)*N + favours resolved
       display_week_score = display.score(time_from, time_to)
       pool_points = display_week_score["pool_size"] * display_week_score["pools_completed"]     
       
       #only take pool_points into account if user has checked in this week
       if checkins > 0
         score["pool_points"] = pool_points 
         score["score"] = pool_points + favours
       else 
         score["pool_points"] = 0
         score["score"] = favours
       end    
    end

    return score
  end


  def has_unread_messages_from(user)
    unread_message = Message.where(:to => [self.id], :from => [user.id]).last
    if !unread_message.nil? then
      return !unread_message.read
    else
      return false
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
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

  def gift!(from, gift_type)
    gifts.create!(from_id: from.id, gift_type: gift_type) 
  end

end
