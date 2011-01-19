module Phrasie
  class Extractor
    # Simple state machine for use in the #phrases method.
    SEARCH = 0
    NOUN = 1
    
    attr_accessor :tagger, :default_filter

    def initialize(filter={})
      self.tagger = Tagger.new
      self.default_filter = {:strength => 2, :occur => 3}.merge(filter)
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
      
      # If the filter is a string containing a percent sign, e.g. '10%', we'll
      #   set the filter's min-occurence value to x% of the input length.
      # 2% on a text length of 100 will mean it needs to occur twice.
      filter = self.default_filter.merge(filter || {})
      if filter[:occur].to_s[/%/]
        filter[:occur] = [(taggedTerms.size * filter[:occur].to_f/100), 2].sort.last.round
      end
      
      terms = Hash.new(0)
      multiterm = []
      
      # Phase 1: A little state machine is used to build simple and
      # composite phrases.
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
            terms[word] += 1
          end
          multiterm = []
        end
      end
      
      # Phase 2: Only select the phrases that fulfill the filter criteria.
      # Also create the phrase strengths.
      return terms \
              .map{|phrase, occurance| [phrase, occurance, phrase.split.size] } \
              .delete_if{|phrase, occurance, strength| !self.validate(phrase, occurance, strength, filter)} \
              .sort_by{|phrase, occurance, strength|  occurance + ((occurance/5.0)*strength) }.reverse
    end

    protected
    
    # Validates the phrase is within the bounds of our filter
    def validate(word, occur, strength, filter)
      occur >= filter[:occur] || (occur >= 2 && strength >= filter[:strength])
    end
    
    # Used within #phrases
    def add(term, norm, multiterm, terms)
      multiterm << [term, norm]
      terms[norm] += 1
    end
  end
end