require 'socket'
require 'thread'
require 'rexml/document'
require './chatter_bot.rb'

class Reply_bear  
  def initialize
	$chatter = Chatter.new
	$julius = TCPSocket.new('localhost',10500)
	$receive_mode = 0
  end

  def talk(message)
	file = File.open("speak.txt","a")
	file.write(message)
	file.close
	system('sh talk.sh')	  
  end 

  def get_word(str)
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

  def process_data
	while line = $julius.gets 
	  if $receive_mode == 0 #Nomal mode
		if line.include?("<RECOGOUT>")
		  $receive_mode = 1 
		  words = line
		  puts "RECEIVE String!!"
		end  
	  elsif $receive_mode == 1 #Get Word mode 
		if line.include?("<\/RECOGOUT>")
		  #返答パターン作成と文字列の初期化、ノーマルモードへ戻す。
		  words += line
		  sentence = get_word(words) 
		  if sentence != nil
			puts "Input Word:#{sentence}"  
			reply = $chatter.create_reply(sentence)
			puts "Reply:#{reply}"
			talk(reply) if reply != nil && reply.start_with?("ところで") == false
		  end
		  words = ""
		  $receive_mode = 0
		else
		  words += line
		end    
	  end		
	end
  end

  def start
	process_data
  end		
end

bear = Reply_bear.new
bear.start
