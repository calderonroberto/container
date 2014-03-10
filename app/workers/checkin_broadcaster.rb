class CheckinBroadcaster

  # This task sends an event to ThingBroker to broadcast a checkin. Currently it's hacked to send an
  # event to an arduino that interprets this as a "water" action. This is all hardcoded here
  # specially the event in req.body. Please remove this or change it to something that can
  # be configured for other purposes

  @queue = :checkins_queue  
  def self.perform(user)
    conn = Faraday.new(:url => 'http://kimberly.magic.ubc.ca:8080') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    # post payload as JSON instead of "www-form-urlencoded" encoding:
    conn.post do |req|
      req.url '/thingbroker/things/containercheckins/events'
      req.headers['Content-Type'] = 'application/json'
      req.body = '{ "type": "case" }'
    end
  end
  
end
