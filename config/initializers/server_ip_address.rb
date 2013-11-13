# to set thingbroker ip address to the same where this application is deployed at
require 'socket'
ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
ip.ip_address if ip
SERVER_IP = ip.ip_address

