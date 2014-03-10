class Checkin < ActiveRecord::Base
  attr_accessible :display_id, :user_id
  belongs_to :user

  validates :user_id, presence: true
  validates :display_id, presence: true

end
