require 'socket'
require 'resolv'

mdmaddr = Resolv.getaddress ENV['Server']

s2 = UDPSocket.new Socket::AF_INET
s2.connect(mdmaddr, 7962)

loop do
  print ("=> ")
  s2.send(gets.chomp!, 0)
end

