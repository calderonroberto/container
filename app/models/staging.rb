class Staging < ActiveRecord::Base
  attr_accessible :app_id
  
  belongs_to :display  
  belongs_to :app 


  validates :app_id, presence: true
  validates :display_id, presence: true
  
end
