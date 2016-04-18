module Phrasie
  class Tagger
    include Phrasie::Rules
    TERM_SPEC = /(\p{Word}+)/
    attr_accessor :language, :tags_by_term, :lexicon

    def initialize(options={})
      self.language = options[:language] || 'english'
      self.lexicon = options[:lexicon] || File.expand_path("#{__FILE__}/../data/#{self.language}-lexicon.txt")
      file = File.read(self.lexicon)
      self.tags_by_term = Hash[file.split("\n").map{|line| line.split.first(2)}]
    end

    # Takes some input text and outputs an array of the words contained in it.
    def tokenize(text)
      terms = []
      text.split(/\s/).each do |term|
        next if term == ''
        match = TERM_SPEC.match(term).to_a
        match.shift
        if match.size == 0
          terms << term
          next
        end

        match.each do |sub_term|
          terms << sub_term if sub_term != ''
        end
      end
      return terms
    end

    # Takes an array from #tokenize, or a string which it pipes through #tokenize,
    #   and returns the words with part-of-speech tags.
    def tag(input)
      if input.is_a? String
        terms = self.tokenize(input)
      elsif input.is_a? Array
        terms = input
      else
        return []
      end

      tagged_terms = []
      terms.each do |term|
        tag = self.tags_by_term[term] || "NND"
        tagged_terms << [term, tag, term]
      end

      # These rules are definied in rules.rb
      rules = [
        'correctDefaultNounTag',
        'verifyProperNounAtSentenceStart',
        'determineVerbAfterModal',
        'normalizePluralForms'
      ]

      tagged_terms.each_with_index do |tagged_term, id|
        rules.each do |rule|
          id, tagged_terms[id], tagged_terms = self.send(rule.to_sym, id, tagged_term, tagged_terms)
        end
      end

      return tagged_terms
    end

  end
end
