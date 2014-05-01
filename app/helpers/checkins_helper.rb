module CheckinsHelper

 def broadcast_checkin(display, user)
    Resque.enqueue(CheckinBroadcaster, display, user)
 end

end
