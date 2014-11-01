class Favour < ActiveRecord::Base
  attr_accessible :id, :from_id, :reciprocated, :to_id

  validates :from_id, presence: true
  validates :to_id, presence: true

end
