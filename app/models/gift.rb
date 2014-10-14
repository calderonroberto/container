class Gift < ActiveRecord::Base
  attr_accessible :from_id, :type, :user_id
  belongs_to :user

  validates :from_id, presence: true
  validates :type, presence: true
  validates :user_id, presence: true

end
