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

 def self.new(token, local=false)

   self.checkParams(token)

   host = Le::Host.new(token, local)      
   logger = Logger.new(host)
   
   logger.formatter = host.formatter

   logger  
 end

 def self.checkParams(token)
	if token == nil
		puts "\nLE: Incorrect token parameter for Logentries Plugin!\n"
	end

	# Check if the key is valid UUID format
	if (token =~ /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i) == nil
		puts "\nLE: It appears the LOGENTRIES_TOKEN you entered is invalid!\n"
	end
 end
end
