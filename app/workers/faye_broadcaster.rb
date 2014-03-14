require 'display_state'

class FayeBroadcaster
  
  #include StatesHelper #needed for the get_state function
  
  @queue = :broadcasters_queue
  def self.perform(display_id)    
    @display = Display.find_by_unique_id(display_id)
    state = DisplayState.get_state(@display)
    url = "/states/#{display_id}"    
    message = {:channel => url, :data => state}
    faye_uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(faye_uri, :message => message.to_json)
  end
  
end
