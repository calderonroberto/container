class App < ActiveRecord::Base
  attr_accessible :description, :name, :thumbnail_url, :url, :mobile_url, :url_uploaded, :mobile_url_uploaded, :thumbnail_url_uploaded
  has_many :subscriptions
  has_many :displays, through: :subscriptions
  has_many :stagings
  has_many :staged_displays, through: :stagings, source: "display"

  has_attached_file :url_uploaded, :path => "apps/:app_name.:extension"
  has_attached_file :mobile_url_uploaded, :path => "apps/:app_name-mobile.:extension"
  has_attached_file :thumbnail_url_uploaded, :path => "apps/:app_name-thumbnail.:extension", :styles => { :thumb => "100x100#" }

  validates :name, uniqueness:true
  validates :description, presence: true

  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*(:[0-9]{1,5})?(\/.*)?$/ix
  VALID_MOBILE_URL_REGEX = /^$|^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*(:[0-9]{1,5})?(\/.*)?$/ix
  VALID_NAME_REGEX = /^[a-zA-Z\d\s]*$/

  validates :url, presence: true, :unless => :url_uploaded?, format: { with: VALID_URL_REGEX }

  validates_attachment :url_uploaded, :size => { :in => 0..550.kilobytes }, :content_type => { :content_type => "text/html" }
  validates_attachment :mobile_url_uploaded, :size => { :in => 0..550.kilobytes }, :content_type => { :content_type => "text/html" }
  validates_attachment :thumbnail_url_uploaded, :size => { :in => 0..2200.kilobytes }, :content_type => { :content_type => [ "image/jpg", "image/png", "image/jpeg" ] }

  validates :name, presence: true, length: { maximum: 50 }, format: {with: VALID_NAME_REGEX}

  def subscribed?(display)
    subscriptions.find_by_display_id(display.id)
  end

  def subscribe!(display)
    subscriptions.create!(display_id: display.id)
  end
 
  def unsubscribe!(display)
    subscriptions.find_by_display_id(display.id).destroy
  end
  
  private  

  # interpolate in paperclip
    Paperclip.interpolates :app_name  do |attachment, style|
     attachment.instance.name.sub(' ', '_')
    end


    

end
