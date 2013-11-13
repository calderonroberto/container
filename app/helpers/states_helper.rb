require 'display_state'

module StatesHelper

 def broadcast_state(display)
    Resque.enqueue(FayeBroadcaster, display.id)
 end

 # instead of using resque (i.e. the appropriate way) you could make
 # your faye post within the helper.
 def broadcast_state_with_rails
    url = "/states/#{current_display.id}"
    broadcast(url, get_state(current_display))
 end

 def broadcast(channel, data)
    message = {:channel => channel, :data => data}
    uri = URI.parse("http://#{request.env['SERVER_NAME']}:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
 end

 def get_state   
   #moved to a custom library to be accessed by worker and this class
   return DisplayState.get_state(current_display)   
 end

end

