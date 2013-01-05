class App < ActiveRecord::Base
  attr_accessible :description, :name, :thumbnail_url, :url
  has_many :subscriptions
  has_many :displays, through: :subscriptions
  has_many :stagings
  has_many :staged_displays, through: :stagings, source: "display"

  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness:true
  validates :description, presence: true

  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*(:[0-9]{1,5})?(\/.*)?$/ix
  validates :url, presence: true, format: { with: VALID_URL_REGEX }


  def subscribed?(display)
    subscriptions.find_by_display_id(display.id)
  end

  def subscribe!(display)
    subscriptions.create!(display_id: display.id)
  end
 
  def unsubscribe!(display) 
    subscriptions.find_by_display_id(display.id).destroy
  end

end
