require 'socket'
require 'thread'

class Julius  
  def initialize
  	@julius = TCPSocket.new('localhost',10500)
  end
  
  def self.clear_xmlstr(line)
    line['<s>'] = ""
	line['</s>'] = ""
    return line
  end

  def self.receve_data
  	while line = @julius.gets
	  line = clear_xmlstr(line)
	  if line.include?("<RECOGOUT>")
		
  end
end
