require 'socket'
require 'thread'
require 'rexml/document'

class Julius  
  def initialize
	@receive_mode = 0
  end

  def self.get_word(str)
	sentence = ""
	str['<s>'] = ""
	str['</s>'] = ""
	xml = REXML::Document.new(str)
	xml.elements.each('RECOGOUT/SHYPO/WHYPO') do |element|
	  hash = element.attributes
	  if hash["WORD"] != nil
		sentence += hash["WORD"]
	  end
	end
	return sentence 
  end

  def self.receive_data
	@julius = TCPSocket.new('localhost',10500)
	receive_mode = 0
	words = ""
	while line = @julius.gets 
	  if receive_mode == 0 #Nomal mode
		if line.include?("<RECOGOUT>")
		  receive_mode = 1 
		  words += line
		  puts "RECEIVE String!!"
		end  
	  elsif receive_mode == 1 #Get Word mode 
		if line.include?("<\/RECOGOUT>")
		  #返答パターン作成と文字列の初期化、ノーマルモードへ戻す。
		  words += line
		  sentence = get_word(words) 
		  puts sentence  
		  words = ""
		  receive_mode = 0
		else
		  words += line
		end    
	  end		
	end
  end

end

julius = Julius.new
Julius.receive_data
