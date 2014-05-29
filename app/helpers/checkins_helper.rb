module CheckinsHelper

 def broadcast_checkin(display, user, thingbroker_url)
    Resque.enqueue(CheckinBroadcaster, display, user, thingbroker_url)
 end

end
