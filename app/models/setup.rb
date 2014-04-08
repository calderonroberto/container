class Setup < ActiveRecord::Base
  attr_accessible :thingbroker_url, :interact_instructions, :display_id
  belongs_to :display

  VALID_URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*(:[0-9]{1,5})?(\/.*)?$/ix
  
  validates :thingbroker_url, presence: true, format: { with: VALID_URL_REGEX }

end
