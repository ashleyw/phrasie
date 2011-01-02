module Rules
  
  # Determine whether a default noun is plural or singular.
  def correctDefaultNounTag(id, tagged_term, tagged_terms)
    term, tag, norm = tagged_term
    if tag == 'NND'
      if term[-1] == 's'
        tagged_term[1] = 'NNS'
        tagged_term[2] = term[0..-2]
      else
        tagged_term[1] = 'NN'
      end
    end
    return [id, tagged_term, tagged_terms]
  end
  
  # Verify that noun at sentence start is truly proper.
  def verifyProperNounAtSentenceStart(id, tagged_term, tagged_terms)
    term, tag, norm = tagged_term
    if ['NNP', 'NNPS'].include?(tag) && (id == 0 || tagged_terms[id-1][1] == '.')
      lower_term = term.downcase
      lower_tag = self.tags_by_term[lower_term]
      if ['NN', 'NNS'].include?(lower_tag)
        tagged_term[0] = tagged_term[2] = lower_term
        tagged_term[1] = lower_tag
      end
    end
    return [id, tagged_term, tagged_terms]
  end
  
  # Determine the verb after a modal verb to avoid accidental noun detection.
  def determineVerbAfterModal(id, tagged_term, tagged_terms)
    term, tag, norm = tagged_term
    return [id, tagged_term, tagged_terms] if tag != 'MD'
    len_terms = tagged_terms.size
    i = id
    i += 1
    while i < len_terms      
      if tagged_terms[i][1] == 'RB'
        i += 1
        next
      end
      
      if tagged_terms[i][1] == 'NN'
        tagged_terms[i][1] = 'VB'
      end
      
      break
    end
        
    return [id, tagged_term, tagged_terms]
  end
  
   
  def normalizePluralForms(id, tagged_term, tagged_terms)
    term, tag, norm = tagged_term
    if ['NNS', 'NNPS'].include?(tag) && term == norm
      # Plural form ends in "s"
      singular = term[0..-2]
      if term[-1] && !self.tags_by_term[singular].nil?
        tagged_term[2] = singular
        return [id, tagged_term, tagged_terms]
      end
      
      # Plural form ends in "es"
      singular = term[0..-3]
      if term[-2..-1] && !self.tags_by_term[singular].nil?
        tagged_term[2] = singular
        return [id, tagged_term, tagged_terms]
      end
      
      # Plural form ends in "ies" (from "y")
      singular = term[0..-4]+'y'
      if term[-3..-1] && !self.tags_by_term[singular].nil?
        tagged_term[2] = singular
        return [id, tagged_term, tagged_terms]
      end
    end
    return [id, tagged_term, tagged_terms]
  end       
end