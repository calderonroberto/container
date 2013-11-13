require 'faye'

Faye::WebSocket.load_adapter('thin')

faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 29, :port => '9292')
run faye_server
