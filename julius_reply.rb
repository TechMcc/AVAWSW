require 'socket'
require 'thread'
require 'rexml/document'
require './chatter_bot.rb'
require 'serialport'

#ReplyBotClassの生成
class Reply_bear  
  def initialize
	$chatter = Chatter.new
	$julius = TCPSocket.new('localhost',10500)
	$receive_mode = 0
	$serialp = SerialPort.new("/dev/ttyACM0",9600)
  end
   
  #発声部分
  def talk(message)
	#喋らせる文字列をspeak.txtに書き込む
	file = File.open("speak.txt","a")
	file.write(message)
	file.close
	#シェルスクリプトでopen-jtalkでwavファイルを作成。その後mplayerで音楽を再生
	system('sh talk.sh')	  
  end 

  def get_word(str)
	sentence = ""
	#Juliusが送ってくるXMLをそのままREXML::Documentすると、要素の中に要素が入っているというエラーが出る
	#そのため、ここで先に置換しておく。
	str['<s>'] = ""
	str['</s>'] = ""
	xml = REXML::Document.new(str)
	#XMLの中の文章の部分を抽出し、それを全部足し合わせる
	xml.elements.each('RECOGOUT/SHYPO/WHYPO') do |element|
	  hash = element.attributes
	  if hash["WORD"] != nil
		sentence += hash["WORD"]
	  end
	end
	return sentence 
  end

  def process_data
	#XMLの受信部分。一行ごとに読み込んでいく。
	while line = $julius.gets 
	  if $receive_mode == 0 #Nomal mode
		if line.include?("<RECOGOUT>")
		  #最初の部分の受信。ここから音声取得モードに切り替える。
		  $receive_mode = 1 
		  words = line
		end  
	  elsif $receive_mode == 1 #Get Word mode 
		if line.include?("<\/RECOGOUT>")
		  #返答パターン作成と文字列の初期化、ノーマルモードへ戻す。
		  words += line
		  sentence = get_word(words) 
		  if sentence != nil
			puts "Input Word:#{sentence}"  
			#サーボモーターとLEDを動作させるためのArduinoとのシリアル通信を行う。
			$serialp.write('T')
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
