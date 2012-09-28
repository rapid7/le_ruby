#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#

require 'socket'
require 'openssl'

module Le
  module Host
    class HTTPS

      class TCPSOCKET

	attr_accessor :conn, :token
	def initialize(token)

          @token = token
	  begin
          	createSocket()
	  rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
		$stderr.puts "WARNING: #{e.class} Could not create the connection to Logentries. #{e.message}"
          end
	end

        def createSocket()

          # Open the TCP connection to the Logentries Server
          @conn = TCPSocket.new('api.logentries.com', 10000)

        end
	
	def deliver(message)

          if @conn == nil
             begin
                createSocket()
             rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
                $stderr.puts "WARNING: #{e.class} Could not write log. No connection to Logentries #{e.message}"
                return
             end
          end
          # Sends the log to the Logentries Server
          begin
	    @conn.puts(@token + message)
	  rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ENOTCONN, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
	    $stderr.puts "WARNING: #{e.class} Could not send log to Logentries #{e.message}"
              begin
                createSocket()
              rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
                $stderr.puts "WARNING: #{e.class} Could not create the connection to Logentries. #{e.message}"
              end
	  end
        end
	
      end

    end
  end
end
