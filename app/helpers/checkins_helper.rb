module CheckinsHelper

 def broadcast_checkin(user)
    Resque.enqueue(CheckinBroadcaster, user)
 end

end
