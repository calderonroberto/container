class Display < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation
  has_many :subscriptions
  has_many :apps, through: :subscriptions 
  
  has_many :stagings
  has_many :staged_apps, through: :stagings, source: "app"
  has_many :notes

  has_one :setup

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  before_save :create_remember_token, :create_unique_id
  after_commit :set_broker_url

  def week_score
    if setup.experimental_setup == 1
      score = Hash["score" => Checkin.where("display_id = ? AND created_at >= ?", self.id, Time.zone.now.beginning_of_week).count ]
    else
      score = Hash["score" => 0 ]
    end

    return score
  end

  def stage!(app)
    if stagings.last.nil?
      stagings.create!(app_id: app.id)
    else
      stagings.last.update_attributes!(app_id: app.id)
    end
  end

  def staged_app
    unless (stagings.last.nil?)
      stagings.last.app
    else
      nil
    end
  end

  private
  
    def create_remember_token
	self.remember_token = SecureRandom.urlsafe_base64
    end
    def create_unique_id
        self.unique_id = Time.now.to_i
    end
    def set_broker_url
        self.setup.thingbroker_url = "http://#{SERVER_IP}:8080/thingbroker"
    end

end
