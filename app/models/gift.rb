class Gift < ActiveRecord::Base
  attr_accessible :from_id, :gift_type, :user_id
  belongs_to :user

  validates :from_id, presence: true
  validates :gift_type, presence: true
  validates :user_id, presence: true

end
