require 'socket'
require 'thread'
require 'rexml/document'
require 'MeCab'

def talk(message)
  file = File.open("speak.txt","a")
  file.write(message + "\n")
  file.close
  system('sh speek.sh')	
end


def parseStr(sentence)
  logfile = File.open("log.txt","a")
  logfile.write(sentence + "\n")
  logfile.close
  if sentence =~ /こんにちは/
	talk("こんにちは")
  elsif sentence =~ /おはよう/
	talk("おはよう")
  elsif sentence =~ /元気/
	talk("げんきですよ!")
  elsif sentence =~ /さようなら/ || sentence =~ /さよなら/
	talk("さよなら")
  elsif sentence =~ /進捗/ || sentence =~ /新宿/
	talk("進捗ダメです")
  elsif sentence =~ /名前は/
	talk("くまたんって言います!")
  elsif
	mecabCli = MeCab::Tagger.new
	node = mecabCli.parseToNode(sentence)
	aisatu_array = []
	name_array = []
	begin 
	  node = node.next
	  if /^感動詞/ =~ node.feature.force_encoding("UTF-8")
		aisatu_array << node.surface.force_encoding("UTF-8")
	  elsif /^名詞/ =~ node.feature.force_encoding("UTF-8")
		name_array << node.surface.force_encoding("UTF-8")
	  end
	end until node.next.feature.include?("BOS/EOS")
	if aisatu_array != []
	  talk(aisatu_array.sample)
	elsif name_array != []
	  talk(name_array.sample + "ってなに?")
	end		  
  end
end  

def xmlparse(str)
  word = ""
  str['<s>'] = ""
  str['</s>'] = ""
  xml = REXML::Document.new(str)
  xml.elements.each('RECOGOUT/SHYPO/WHYPO') do |element|
	hash = element.attributes
	word += hash["WORD"]
  end
  puts word
  parseStr(word)
end

tcpserver = TCPSocket.new 'localhost',10500

xmlstr = ""

while line = tcpserver.gets
  if line =~ /<RECOGOUT>/
	flag = 1
  elsif line =~ /<\/RECOGOUT>/
	flag = 0
	xmlstr += line
	xmlparse(xmlstr)
	xmlstr = ""
  end
  if flag == 1
	puts line
	xmlstr += line
  end
end

