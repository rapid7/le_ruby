#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#

module Le
  module Host
    class HTTPS

      class TCPSOCKET

	attr_accessor :sock, :conn
	def initialize(key, location)

          # Create the unique address comprising of user-key and location of file on logentries server
	  addr = sprintf('/%s/hosts/%s/?realtime=1', key, location)	  
	
          # Open the TCP connection to the Logentries Server
	  @sock = TCPSocket.new('api.logentries.com', 443)

	  @conn = OpenSSL::SSL::SSLSocket.new(@sock, OpenSSL::SSL::SSLContext.new())
	  @conn.sync_close = true
          @conn.connect

          # Set up connection with Logentries API to receive messages in chunks, i.e, logs
	  request = sprintf("PUT %s HTTP/1.1\r\n", addr)
          @conn.print(request)
	  @conn.print("Accept-Encoding: identity\r\n")
	  @conn.print("Transfer_Encoding: chunked\r\n\r\n")
	end
	
	def deliver(message)

          # Sends the log to the Logentries Server
          begin
	    @conn.print(message + "\r\n")
	  rescue OpenSSL::SSL::SSLError, TimeoutError, Errno::ECONNRESET, EOFError => e
	    $stderr.puts "WARNING: #{e.class} sending log #{message}"
	  end
        end
	
      end

    end
  end
end
