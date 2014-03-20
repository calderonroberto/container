class Registration < ActiveRecord::Base
  attr_accessible :display_id, :user_id
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => :display_id
end
