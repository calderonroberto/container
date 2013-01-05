class Message < ActiveRecord::Base
  attr_accessible :from, :message
  belongs_to :display

  validates :from, presence: true
  validates :message, presence: true
  validates :display_id, presence: true
end
