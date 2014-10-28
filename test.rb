require 'socket'
require 'thread'

server = TCPSocket.new 'localhost',10500

while line = server.gets
  puts line
end
