#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#

module Le
  module Host
    
    # Creates a new Logentries host, based on a user-key and location of destination file on logentries,
    # both must be provided correctly for a connection to be made.

    def self.new(key, location, local)

      Le::Host::HTTPS.new(key, location, local)
      
    end
  
    module HelperMethods
 
      def formatter
	proc do |severity, datetime, progname, msg|
	  message = "#{datetime} "
          message << format_message(msg, severity)
        end
      end
  
      def format_message(msg_in, severity)
	msg_in = msg_in.lstrip
	msg_out = ""
	msg_out << "severity=#{severity}, "

	case msg_in
	when String
		msg_out << msg_in
	else
		msg_out << msg_in.inspect
        end
	msg_out
      end
    end
  end
end

require File.join(File.dirname(__FILE__), 'host', 'https')
