require 'csv'
require 'uri'
require 'json'
require 'openssl'
require 'net/http'
require './keys.rb'

class Chatter
  def initilaize
    $context = ""
  end
  
  def pattern_match(sentence)
    CSV.foreach("pattern.csv") do |pattern|
      if sentence.include?(pattern[0])
	    return pattern[1]
	  end
	end	  
	return -1
  end
  
  def docomo_reply(sentence)
    uri = URI.parse("https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=#{APIKEY}")
    http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	body = {'utt' => sentence}
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json'})
	request.body = body.to_json
	http.start do |h|
	  	resp = h.request(request)
	    response = JSON.parse(resp.body)
		$context = response['context']
		if response['utt'].include?("<") == false
		  return response['utt']
		end
	end
  end

  def create_reply(sentence) 
   if pattern_match(sentence) != -1
	 return pattern_match(sentence)
   elsif sentence.length  > 3
	 return docomo_reply(sentence)
   end
  end
end


