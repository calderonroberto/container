class Message < ActiveRecord::Base
  attr_accessible :from, :message, :to, :read

  validates :from, presence: true
  validates :message, presence: true
  validates :to, presence: true
end
