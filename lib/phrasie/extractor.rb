module Phrasie
  class Extractor
    # Simple state machine for use in the #phrases method.
    SEARCH = 0
    NOUN = 1
    
    attr_accessor :tagger, :filter

    def initialize(options={})
      self.tagger = Tagger.new
      self.filter = {:strength => 2, :occur => 3}.merge(options[:filter] || {})
    end
    
    def to_s
      "#<Phrasie::Extractor>"
    end
    
    # Returns an array of arrays in the format of: 
    #   [phrase, # of occurances, # of words in phrase]
    def phrases(input, filter=nil)
      if input.is_a? String
        taggedTerms = self.tagger.tag(input)
      elsif input.is_a? Array
        taggedTerms = input
      else
        return []
      end
            
      unless filter.nil?
        self.filter = self.filter.merge(filter)
        if self.filter[:occur].to_s[/%/]
          self.filter[:occur] = [(taggedTerms.size * 0.01), 2].sort.last.round
        end
      end

      terms = {}
      multiterm = []
      
      state = SEARCH
      
      while taggedTerms.size > 0
        term, tag, norm = taggedTerms.shift
        if state == SEARCH && tag[0,1] == "N"
          state = NOUN
          add(term, norm, multiterm, terms)
        elsif state == SEARCH && tag == 'JJ' && term[0,1].upcase == term[0,1]
          state = NOUN
          add(term, norm, multiterm, terms)
        elsif state == NOUN && tag[0,1] == "N"
          add(term, norm, multiterm, terms)
        elsif state == NOUN && tag[0,1] != "N"
          state = SEARCH
          if multiterm.size > 1
            word = multiterm.map(&:first).join(' ')
            terms[word] ||= 0
            terms[word] += 1
          end
          multiterm = []
        end
      end
      
      return terms \
              .map{|phrase, occurance| [phrase, occurance, phrase.split.size] } \
              .delete_if{|arr| !self.validate(*arr)} \
              .sort_by{|phrase, occurance, strength|  occurance + ((occurance/5.0)*strength) }.reverse
    end

    protected
    
    # Validates the phrase is within the bounds of our filter
    def validate(word, occur, strength)
      occur >= self.filter[:occur] || (occur >= 2 && strength >= self.filter[:strength])
    end
    
    # Used within #phrases
    def add(term, norm, multiterm, terms)
      multiterm << [term, norm]
      terms[norm] ||= 0
      terms[norm] += 1
    end
  end
end