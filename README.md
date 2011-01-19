# Phrasie — Term Extractor

## DESCRIPTION:

Determines important terms within a given piece of content. It
uses linguistic tools such as Parts-Of-Speech (POS) and some simple
statistical analysis to determine the terms and their strength.

Based on the excellent Python library [topia.termextract](http://pypi.python.org/pypi/topia.termextract/).

**Tested on Ruby 1.8.7 and 1.9.2.**

## SYNOPSIS:
    
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
    
    extractor = Phrasie::Extractor.new

    extractor.phrases(text)
    
    # [["Jerusalem", 8, 1],
    #  ["Palestinian", 6, 1],
    #  ["event", 6, 1],
    #  ["East Jerusalem", 4, 2],
    #  ["East", 4, 1],
    #  ["police", 4, 1],
    #  ["Israel", 4, 1],
    #  ["theatre", 3, 1],
    #  ["Palestinian theatre", 2, 2],
    #  ["Palestinian Authority", 2, 2]]
    
    
By default the results are filtered to only keep words/phrases which occur at least 3 times, or occur at least twice and have a word count of more than 2. Here's how you'd modify this behaviour:
    
    extractor = Phrasie::Extractor.new
    extractor.phrases(some_text, :strength => 2, :occur => 3)
    
or globally:

   extractor = Phrasie::Extractor.new(:strength => 2, :occur => 3)

or take full control and filter it yourself with `keep_if`.

## INSTALL:

    gem install phrasie

or in your Gemfile:

    gem 'phrasie'

## LICENSE:

Copyright 2010 Ashley Williams \<<hi@ashleyw.co.uk>\>  
Copyright 2009 Stephan Richter, Russ Ferriday and the Zope Community (Original Python implementation)  

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
