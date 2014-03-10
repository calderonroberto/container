Rails.application.config.middleware.use OmniAuth::Builder do
  # The following is for facebook
  #provider :facebook, ENV['APP ID'], ENV['SECRET KEY'], {:scope => 'email, read_stream, read_friendlists, friends_likes, friends_status, offline_access'}
 
  # If you want to also configure for additional login services, they would be configured here.
end
