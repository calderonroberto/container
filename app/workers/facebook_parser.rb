
class FacebookParser
  @queue = :facebook_queue
  def self.perform(uid)
    user = User.find_by_uid(uid)
    token = user.token
    graph = Koala::Facebook::API.new(token)    
    user.friends = graph.get_connections("me", "friends")
    user.save
  end
end
