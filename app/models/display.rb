class Display < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation
  has_many :subscriptions
  has_many :apps, through: :subscriptions 
  
  has_many :stagings
  has_many :staged_apps, through: :stagings, source: "app"
  has_many :messages

  has_one :setup

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  before_save :create_remember_token, :create_unique_id

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

end
