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

 def self.new(key, location)

   host = Le::Host.new(key, location)      
   logger = Logger.new(host)
   
   logger.formatter = host.formatter

   logger  
 end

end
