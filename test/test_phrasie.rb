require 'test_helper.rb'

class TestPhrasie < Test::Unit::TestCase
  def setup
    @text = 'The British consul of Boston resides in Newton. The British consul is awesome.'
    @long_text = %(Police shut Palestinian theatre in Jerusalem.
    
    Israeli police have shut down a Palestinian theatre in East Jerusalem.
    
    The action, on Thursday, prevented the closing event of an international
    literature festival from taking place.
    
    Police said they were acting on a court order, issued after intelligence
    indicated that the Palestinian Authority was involved in the event.
    
    Israel has occupied East Jerusalem since 1967 and has annexed the
    area. This is not recognised by the international community.
    
    The British consul-general in Jerusalem , Richard Makepeace, was
    attending the event.
    
    "I think all lovers of literature would regard this as a very
    regrettable moment and regrettable decision," he added.
    
    Mr Makepeace said the festival's closing event would be reorganised to
    take place at the British Council in Jerusalem.
    
    The Israeli authorities often take action against events in East
    Jerusalem they see as connected to the Palestinian Authority.
    
    Saturday's opening event at the same theatre was also shut down.
    
    A police notice said the closure was on the orders of Israel's internal
    security minister on the grounds of a breach of interim peace accords
    from the 1990s.
    
    These laid the framework for talks on establishing a Palestinian state
    alongside Israel, but left the status of Jerusalem to be determined by
    further negotiation.
    
    Israel has annexed East Jerusalem and declares it part of its eternal
    capital.
    
    Palestinians hope to establish their capital in the area.)
    @extractor = Phrasie::Extractor.new
  end
  
  def test_extractor
    expected = [["British consul", 2, 2]]
    assert_equal expected, @extractor.phrases(@text).sort_by{|a| a[1]}
  end
  
  def test_non_words
    text = %(LONDON - WikiLeaks founder Julian Assange was refused bail and jailed for a week by a British court Tuesday, pending an extradition hearing over alleged sex offenses in Sweden.
    Assange turned himself in to U.K. police earlier in the day in the latest blow to his WikiLeaks organization, which faces legal, financial and technological challenges after releasing hundreds of secret U.S. diplomatic cables.
    Swedish prosecutors had issued an arrest warrant for the 39-year-old Australian, who is accused of sexual misconduct with two women.
    Assange surrendered at 9:30 a.m. local time (4:30 a.m. ET) Tuesday. The U.K.'s Guardian newspaper reported that Assange later arrived at a London court accompanied by British lawyers Mark Stephens and Jennifer Robinson.
    During his court appearance, Assange said he would fight extradition to Sweden and he provided the court with an Australian address. Britain's Sky News reported that Assange was receiving consular assistance from officials at the Australian High Commission.
    The next court hearing is scheduled for next Tuesday, and Assange will remain in custody until then because he was deemed to be a flight risk.
    Judge Howard Riddle asked Assange whether he understood that he could agree to be extradited to Sweden. Assange, dressed in a navy blue suit, cleared his throat and said: "I understand that and I do not consent."
    The judge said he had grounds to believe that the former computer hacker - a self-described homeless refugee - might not show up to his next hearing if he were granted bail.
    Arguments during the hour-long hearing detailed the sex accusations against Assange, all of which he has denied.
    Australian journalist John Pilger, British film director Ken Loach and Jemima Khan, former wife of Pakistani cricketer and politician Imran Khan, all offered to put up sureties to persuade the court Assange would not flee.)
    assert_equal 7, @extractor.phrases(text).size
  end
  
  def test_long_text
    assert_equal 10, @extractor.phrases(@long_text).size
  end
  
  def test_filter_options
    assert_equal 7, @extractor.phrases(@long_text, :occur => 4, :strength => 3).size
  end
  
  def test_extractor_to_s
    assert @extractor.to_s == "#<Phrasie::Extractor>"
  end
end
