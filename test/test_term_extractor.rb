require File.dirname(__FILE__) + '/test_helper.rb'

class TestTermExtractor < Test::Unit::TestCase
  def setup
    @text = 'The German consul of Boston resides in Newton.'
    @extractor = TermExtractor.new
  end
  
  def test_extractor
    expected = [["Newton", 1, 2], ["Boston", 1, 2], ["German consul", 1, 2], ["consul", 1, 2], ["German", 1, 2]]
    assert_equal expected, @extractor.extract(@text).sort_by{|a| a[1]}
  end
  
  def test_long_text
    text = %(Police shut Palestinian theatre in Jerusalem.
    
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
    
    @extractor.extract(text).each do |line|
      print "#{line.inspect}\n"
    end
    
    # [["East Jerusalem", 4, 2]
    # ["Palestinian Authority", 2, 2]
    # ["Palestinian theatre", 2, 2]
    # ["British Council", 1, 2]
    # ["police notice", 1, 2]
    # ["opening event", 1, 2]
    # ["Israeli authorities", 1, 2]
    # ["security minister", 1, 2]
    # ["Mr Makepeace", 1, 2]
    # ["peace accords", 1, 2]
    # ["British consul-general", 1, 2]
    # ["Israeli police", 1, 2]
    # ["Palestinian state", 1, 2]
    # ["court order", 1, 2]
    # ["literature festival", 1, 2]
    # ["Palestinians hope", 1, 2]
    # ["Richard Makepeace", 1, 2]
    # ["Jerusalem", 8, 1]
    # ["Palestinian", 6, 1]
    # ["event", 6, 1]
    # ["Israel", 4, 1]
    # ["police", 4, 1]
    # ["East", 4, 1]
    # ["theatre", 3, 1]]
    
    assert_equal 24, @extractor.extract(text).size
  end
end