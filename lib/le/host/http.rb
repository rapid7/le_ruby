require 'socket'
require 'openssl'
require 'thread'
require 'uri'

module Le
  module Host
    class HTTP
	  API_SERVER = 'data.logentries.com'
	  API_PORT = 10000
      include Le::Host::InstanceMethods
      attr_accessor :token, :queue, :started, :thread, :conn, :local, :debug

      def initialize(token, local, debug)
		if defined?(Rails)
			@logger_console = Logger.new("log/#{Rails.env}.log")
		else
			@logger_console = Logger.new(STDOUT)
		end
		@token = token
		@local = local
		@debug = debug
		@queue = Queue.new
		@started = false
		@thread = nil

		if @debug then
			self.init_debug
		end
      end

	  def init_debug
			filePath = "logentriesGem.log"
			if File.exist?('log/')
				filePath = "log/logentriesGem.log"
			end
			@debug_logger = Logger.new(filePath)
	  end

	  def dbg(message)
		if @debug then
			@debug_logger.add(Logger::Severity::DEBUG,message)
		end
	  end

      def write(message)
		if @local then
			@logger_console.add(Logger::Severity::UNKNOWN,message)
		end

		@queue << "#{@token}#{message}\n"

		if @started then
			check_async_thread
		else
			start_async_thread
		end
      end

	  def start_async_thread
		@thread = Thread.new{run()}
		dbg "LE: Asynchronous socket writer started"
		@started = true
	  end

	  def check_async_thread
		if not @thread.alive?
			@thread = Thread.new{run()}
			dbg "LE: Asyncrhonous socket writer restarted"
		end
	  end

      def close
		dbg "LE: Closing asynchronous socket writer"
		@started = false
      end

	  def openConnection
		dbg "LE: Reopening connection to Logentries API server"
		@conn = TCPSocket.new(API_SERVER, API_PORT)

		dbg "LE: Connection established"
	  end

	  def reopenConnection
		closeConnection
		root_delay = 0.1
		while true
			begin
				openConnection
				break
			rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError => e
				dbg "LE: Unable to connect to Logentries"
			end
			root_delay *= 2
			if root_delay >= 10 then
				root_delay = 10
			end
			wait_for = (root_delay + rand(root_delay)).to_i
			dbg "LE: Waiting for " + wait_for.to_s + "ms"
			sleep(wait_for)
		end
	  end

	  def closeConnection
		if @conn != nil
			@conn.sysclose
			@conn = nil
		end
	  end

	  def run
		reopenConnection

		while true
			data = @queue.pop
			while true
				begin
					@conn.write(data)
				rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEOUT, EOFError => e
					reopenConnection
					next
				end
				break
			end
		end
		dbg "LE: Closing Asyncrhonous socket writer"
		closeConnection
	  end
    end
  end
end
