class Log < ActiveRecord::Base  
  attr_accessible :controller, :display_id, :method, :user_id, :params, :app_id, :remote_ip
  serialize :params
end
