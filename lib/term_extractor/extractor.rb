SEARCH = 0
NOUN = 1

class TermExtractor
  attr_accessor :tagger, :filter
  
  def initialize(options={})
    self.tagger = Tagger.new
    self.filter = options[:filter] || {:strength => 2, :occur => 3}
  end
  
  def extract(input, min_occur=3)
    if input.is_a? String
      taggedTerms = self.tagger.tag(input)
    elsif input.is_a? Array
      taggedTerms = input
    else
      return []
    end
                
    terms = {}
    multiterm = []
    state = SEARCH
        
    while taggedTerms.size > 0
      term, tag, norm = taggedTerms.shift
      if state == SEARCH && tag[0] == "N"
        state = NOUN
        add(term, norm, multiterm, terms)
      elsif state == SEARCH && tag == 'JJ' && term[0].upcase == term[0]
        state = NOUN
        add(term, norm, multiterm, terms)
      elsif state == NOUN && tag[0] == "N"
        add(term, norm, multiterm, terms)
      elsif state == NOUN && tag[0] != "N"
        state = SEARCH
        if multiterm.size > 1
          word = multiterm.map(&:first).join(' ')
          terms[word] ||= 0
          terms[word] += 1
        end
        multiterm = []
      end
    end
          
    return terms
            .map{|phrase, occurance| [phrase, occurance, phrase.split.size] } \
            .delete_if{|arr| !self.validate(*arr)} \
            .sort_by{|phrase, occurance, strength|  occurance + ((occurance/5.0)*strength) }.reverse
  end
  
  protected
  def validate(word, occur, strength)
    (strength == 1 && occur >= self.filter[:occur]) || strength >= self.filter[:strength]
  end
  
  def add(term, norm, multiterm, terms)
    multiterm << [term, norm]
    terms[norm] ||= 0
    terms[norm] += 1
  end
end