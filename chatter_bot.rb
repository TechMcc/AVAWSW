require 'csv'

#ChatterBot Class

class Chatter
  def pattern_match(sentence)
    CSV.foreach("pattern.csv") do |pattern|
      if sentence.include?(pattern[0])
	    return pattern[1]
	  end
	end	  
  end
  
  def create_reply(sentence) 
   return pattern_match(sentence) 
  end
end

