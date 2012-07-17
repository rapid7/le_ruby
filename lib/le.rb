#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#

require File.join(File.dirname(__FILE__), 'le', 'host')

require 'logger'

module Le

 def self.new(key, location, local=false)

   self.checkParams(key, location)

   host = Le::Host.new(key, location, local)      
   logger = Logger.new(host)
   
   logger.formatter = host.formatter

   logger  
 end

 def self.checkParams(key, location)
	if key == nil or location == nil
		puts "LE: Incorrect parameters for Logentries Plugin"
	end

	# Check if the key is valid UUID format
	if (key =~ /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i) == nil
		puts "LE: It appears the LOGENTRIES_ACCOUNT_KEY you entered is invalid"
	end
 end
end
