require 'socket'
require 'timeout'

STDOUT.sync = true
s1 = UDPSocket.new Socket::AF_INET
s1.bind('0.0.0.0', 4208)    # RSPI
s2 = UDPSocket.new Socket::AF_INET
s2.bind('0.0.0.0', 7962)    # ULNX

$newline = ->{}
def newline
  puts
  $hb = 0
  $lmg = ""
  $newline = ->{}
end

$hb = 0
$lmg = ""
def heartbeating(mesg)
  unless mesg === $lmg
    $newline[]
  end
  $lmg = mesg

  case $hb += 1
  when 1
    puts mesg
  when 2
    print ' => heartbeat.'
    $newline = ->{newline}
  when 3..nil
    print '.'
  end
end

loop do
  Timeout::timeout(15) do
    srdy = IO.select([s1, s2]).first
    srdy.each do |s|
      msg, addr = s.recvfrom_nonblock(256)
      if (msg == 'RASPI')
        _, $p, $h, _ = addr
        heartbeating " => (bind) #{$h}:#{$p}"
      else
        $newline[]
        if $h.nil? then puts " => (discard) #{msg}"; next end
        puts " => (RASPI) #{msg}"
        s1.send(msg, 0, $h, $p)
      end
    end
  end
rescue Timeout::Error
  $newline[]
  puts " => (TIMEOUT) Rasperry Pi disconnected"
  $h = nil; $p = nil
  retry
end

