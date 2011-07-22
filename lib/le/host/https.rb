#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#

require 'socket'
require 'openssl'

require File.join(File.dirname(__FILE__), 'https', 'tcp')

module Le
  module Host
    class HTTPS
      include Le::Host::HelperMethods	
      
      attr_reader :deliverer

      def initialize(key, location)

        @deliverer = Le::Host::HTTPS::TCPSOCKET.new(key, location)
           
      end

      def write(message)

        # In the Heroku environment, this puts command will write the message to standard Heroku logs also
        puts message
        # Deliver the message to logentries via TCP
	@deliverer.deliver(message)
      end

      def close
	nil
      end
    
    end
  end
end
