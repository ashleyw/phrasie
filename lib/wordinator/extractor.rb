SEARCH = 0
NOUN = 1

module Wordinator
  class Extractor
    attr_accessor :tagger, :filter

    def initialize(options={})
      self.tagger = Tagger.new
      self.filter = options[:filter] || {:strength => 2, :occur => 3}
    end
    
    def to_s
      "#<Wordinator::Extractor>"
    end

    def phrases(input, min_occur=3)
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
              .keep_if{|arr| self.validate(*arr)} \
              .sort_by{|phrase, occurance, strength|  occurance + ((occurance/5.0)*strength) }.reverse
    end

    protected
    def validate(word, occur, strength)
      occur >= self.filter[:occur] || (occur >= 2 && strength >= self.filter[:strength])
    end

    def add(term, norm, multiterm, terms)
      multiterm << [term, norm]
      terms[norm] ||= 0
      terms[norm] += 1
    end
  end
end