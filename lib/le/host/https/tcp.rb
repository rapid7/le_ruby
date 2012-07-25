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
	require 'uri'

	attr_accessor :sock, :conn, :key, :location
	def initialize(key, location)

          @key = key
          @location = URI::encode(location)
	  begin
          	createSocket(@key, @location)
	  rescue OpenSSL::SSL::SSLError, TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
		$stderr.puts "WARNING: #{e.class} creating the connection to Logentries. #{e.message}"
          end
	end

        def createSocket(key, location)
	  
          addr = sprintf('/%s/hosts/%s/?realtime=1', key, location)

          # Open the TCP connection to the Logentries Server
          @sock = TCPSocket.new('api.logentries.com', 443)

          @conn = OpenSSL::SSL::SSLSocket.new(@sock, OpenSSL::SSL::SSLContext.new())
          @conn.sync_close = true
          @conn.connect

          # Set up connection with Logentries API to receive messages in chunks, i.e, logs
          request = sprintf("PUT %s HTTP/1.1\r\n\r\n", addr)
          @conn.write(request)

        end
	
	def deliver(message)

          if @conn == nil
             begin
                createSocket(@key, @location)
             rescue OpenSSL::SSL::SSLError, TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
                $stderr.puts "WARNING: #{e.class} Could not write log. No connection to Logentries #{e.message}"
                return
             end
          end
          # Sends the log to the Logentries Server
          begin
	    @conn.print(message + "\r\n")
	  rescue OpenSSL::SSL::SSLError, TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ENOTCONN, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
	    $stderr.puts "WARNING: #{e.class} sending log #{e.message}"
              begin
                createSocket(@key, @location)
              rescue OpenSSL::SSL::SSLError, TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
                $stderr.puts "WARNING: #{e.class} creating the connection to Logentries. #{e.message}"
              end
	  end
        end
	
      end

    end
  end
end
