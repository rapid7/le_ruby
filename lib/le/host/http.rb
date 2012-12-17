require 'socket'
require 'openssl'
require 'thread'
require 'uri'

module Le
  module Host
    class HTTP
      include Le::Host::InstanceMethods
      attr_accessor :token, :queue, :started, :thread, :conn, :local

      def initialize(token, local)
		@token = token
		@local = local
        @queue = Queue.new
		@started = false
      end

      def write(message)
		if @local then
		  puts message
		  return
		end

		@queue << "#{@token}#{message}\n"

	    if not @started then
			puts "LE: Starting asynchronous socket writer"
			@thread = Thread.new{run()}
			@started = true
		end
      end

      def close
		puts "LE: Closing asynchronous socket writer"
		@thread.raise Interrupt
      end

	  def openConnection
		puts "LE: Reopening connection to Logentries API server"
		@conn = TCPSocket.new('api.logentries.com', 10000)

		#@conn = OpenSSL::SSL::SSLSocket.new(@sock, OpenSSL::SSL::SSLContext.new())
		#@conn.connect

		puts "LE: Connection established"
	  end

	  def reopenConnection
		closeConnection
		root_delay = 0.1
		while true
			begin
				openConnection
				break
			rescue OpenSSL::SSL::SSLError, TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
				puts "LE: Unable to connect to Logentries"
			end
			root_delay *= 2
			if root_delay >= 10 then
				root_delay = 10
			end
			wait_for = (root_delay + rand(root_delay)).to_i
			puts "LE: Waiting for " + wait_for.to_s + "ms"
			sleep(wait_for)
		end
	  end

	  def closeConnection
		if @conn != nil
			@conn.sysclose
			@conn = nil
		end
		#if @sock != nil
		#	@sock.close
		#	@sock = nil
		#end
	  end

	  def run
		begin
		reopenConnection

			while true
				data = @queue.pop
				while true
					begin
						@conn.write(data)
					rescue OpenSSL::SSL::SSLError, TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEOUT, EOFError => e
						reopenConnection
						next
					end
					break
				end
			end
		rescue Interrupt 
		  puts "LE: Asynchronous socket writer interrupted"
		end
		closeConnection
	  end
    end
  end
end
