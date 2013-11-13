class Subscription < ActiveRecord::Base
  attr_accessible :app_id, :display_id
  belongs_to :display
  belongs_to :app
  
  validates :app_id, presence: true
  validates :display_id, presence: true

end
