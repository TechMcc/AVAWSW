require 'socket'
require 'thread'
require 'rexml/document'
require 'MeCab'

  

def parseStr(sentence)
  mecabcli = MeCab::Tagger.new
  node = mecabcli.parseToNode(sentence)
  word_array = []
  begin
	node = node.next
	puts "#{node.surface}\t#{node.feature}"
	if /^感動詞/ =~ node.feature.force_encoding("UTF-8")
	  word_array << node.surface.force_encoding("UTF-8")
	end
  end until node.next.feature.include?("BOS/EOS")
  puts word_array
  if word_array != []
	talk(word_array.sample)
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

