#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#

require File.join(File.dirname(__FILE__), 'https', 'tcp')

module Le
  module Host
    class HTTPS
      include Le::Host::HelperMethods	
      
      attr_reader :deliverer, :local_bool

      def initialize(token, local)
	@local_bool = local
	if not local
        	@deliverer = Le::Host::HTTPS::TCPSOCKET.new(token)
        end   
      end

      def write(message)
	
	if @local_bool
        	puts message
        else
        	# Deliver the message to logentries via TCP
		@deliverer.deliver(message)
	end
      end

      def close
	nil
      end
    
    end
  end
end
