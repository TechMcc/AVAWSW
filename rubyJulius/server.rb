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

