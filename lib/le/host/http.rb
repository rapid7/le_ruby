require 'socket'
require 'openssl'
require 'thread'
require 'uri'

module Le
  module Host
    class HTTP
      LIBRARY_IDENTIFIER = '###R01### - Library initialised'
#      API_SERVER = 'api.logentries.com'
      API_SERVER = 'api.logentries.com'

      API_PORT = 10000
      API_SSL_PORT = 20000
      API_CERT = '-----BEGIN CERTIFICATE-----
MIIFSjCCBDKgAwIBAgIDCQpNMA0GCSqGSIb3DQEBBQUAMGExCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMR0wGwYDVQQLExREb21haW4gVmFsaWRh
dGVkIFNTTDEbMBkGA1UEAxMSR2VvVHJ1c3QgRFYgU1NMIENBMB4XDTE0MDQxNTEz
NTcxNVoXDTE2MDkxMzA0MTMzMFowgcExKTAnBgNVBAUTIEhpL1RHbXlmUEpJYTFy
b0NQdlJ1U1NNRVdLOFp0NUtmMRMwEQYDVQQLEwpHVDAzOTM4NjcwMTEwLwYDVQQL
EyhTZWUgd3d3Lmdlb3RydXN0LmNvbS9yZXNvdXJjZXMvY3BzIChjKTEyMS8wLQYD
VQQLEyZEb21haW4gQ29udHJvbCBWYWxpZGF0ZWQgLSBRdWlja1NTTChSKTEbMBkG
A1UEAxMSYXBpLmxvZ2VudHJpZXMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAwGsgjVb/pn7Go1jqNQVFsN+VEMRFpu7bJ5i+Lv/gY9zXBDGULr3d
j9/hB/pa49nLUpy9GsaFru2AjNoveoVoe5ng2QhZRlUn77hxkoZsaiD+rrH/D/Yp
LP3b/pNQg+nNTC81uwbhlxjIoeMSaPGjr1SFjZ1StCprZKFRu3IV+2/wZ+STUz/L
aA3r6J86DRptasbzYMkDyWlUzN3nhYUcPUNrd4jSk+soSDEuDpHMahgRdQBo6Dht
EKCSY+vB5ZIgEydI7mra8ygRjXotvc0zeb8Jvo8ZhyLDwvxjgo9F6Li3h/tfAjRR
4ngV7yg9o8MgXN852GMHpUxzqhygLeyqSQIDAQABo4IBqDCCAaQwHwYDVR0jBBgw
FoAUjPTZkwpHvACgSs5LdW6gtrCyfvwwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQW
MBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHREEFjAUghJhcGkubG9nZW50cmll
cy5jb20wQQYDVR0fBDowODA2oDSgMoYwaHR0cDovL2d0c3NsZHYtY3JsLmdlb3Ry
dXN0LmNvbS9jcmxzL2d0c3NsZHYuY3JsMB0GA1UdDgQWBBRowYR/aaGeiRRQxbaV
1PI8hS4m9jAMBgNVHRMBAf8EAjAAMHUGCCsGAQUFBwEBBGkwZzAsBggrBgEFBQcw
AYYgaHR0cDovL2d0c3NsZHYtb2NzcC5nZW90cnVzdC5jb20wNwYIKwYBBQUHMAKG
K2h0dHA6Ly9ndHNzbGR2LWFpYS5nZW90cnVzdC5jb20vZ3Rzc2xkdi5jcnQwTAYD
VR0gBEUwQzBBBgpghkgBhvhFAQc2MDMwMQYIKwYBBQUHAgEWJWh0dHA6Ly93d3cu
Z2VvdHJ1c3QuY29tL3Jlc291cmNlcy9jcHMwDQYJKoZIhvcNAQEFBQADggEBAAzx
g9JKztRmpItki8XQoGHEbopDIDMmn4Q7s9k7L9nT5gn5XCXdIHnsSe8+/2N7tW4E
iHEEWC5G6Q16FdXBwKjW2LrBKaP7FCRcqXJSI+cfiuk0uywkGBTXpqBVClQRzypd
9vZONyFFlLGUwUC1DFVxe7T77Dv+pOPuJ7qSfcVUnVtzpLMMWJsDG6NHpy0JhsS9
wVYQgpYWRRZ7bJyfRCJxzIdYF3qy/P9NWyZSlDUuv11s1GSFO2pNd34p59GacVAL
BJE6y5eOPTSbtkmBW/ukaVYdI5NLXNer3IaK3fetV3LvYGOaX8hR45FI1pvyKYvf
S5ol3bQmY1mv78XKkOk=
-----END CERTIFICATE-----'
      SHUTDOWN_COMMAND = "DIE!DIE!"  # magic command string for async worker to shutdown
      SHUTDOWN_MAX_WAIT = 10         # max seconds to wait for queue to clear on shutdown
      SHUTDOWN_WAIT_STEP = 0.2       # sleep duration (seconds) while waiting to shutdown


      include Le::Host::InstanceMethods
#!      attr_accessor :token, :queue, :started, :thread, :conn, :local, :debug, :ssl, :datahub_enabled, :dathub_ip, :datahub_port, :host_id, :custom_host, :host_name_enabled, :host_name
      attr_accessor :token, :queue, :started, :thread, :conn, :local, :debug, :ssl, :datahub_enabled, :datahub_ip, :datahub_port, :datahub_endpoint, :host_id, :host_name_enabled, :host_name, :custom_host


      def initialize(token, local, debug, ssl, datahub_endpoint, host_id, custom_host)
          if local
            device = if local.class <= TrueClass
              if defined?(Rails)
                Rails.root.join("log","#{Rails.env}.log")
              else
                STDOUT
              end
            else
            local
            end
          @logger_console = Logger.new(device)
          end
        
          @local = !!local
          @debug= debug  
          @ssl = ssl

        @datahub_endpoint = datahub_endpoint
        if !@datahub_endpoint[0].empty?           
          @datahub_enabled=true
          @datahub_ip="#{@datahub_endpoint[0]}"
          @datahub_port=@datahub_endpoint[1]
        else
          @datahub_enabled=false  
        end


        if (@datahub_enabled && @ssl)
          puts ("\n\nYou Cannot have DataHub and SSL enabled at the same time.  Please set SSL value to false in your environment.rb file or used Token-Based logging by leaving the Datahub IP address blank. Exiting application. \n\n")
          exit 
        end


 #check if DataHub is enabled... if datahub is not enabled, set the token to the token's parameter.  If DH is enabled, make the token empty.
        if (!datahub_enabled)
           @token = token
        else
          @token = ''

 #! NOTE THIS @datahub_port conditional MAY NEED TO BE CHANGED IF SSL CAN'T WORK WITH DH        
          @datahub_port = @datahub_port.empty? ?  API_SSL_PORT : datahub_port
          @datahub_ip = datahub_ip
        end

        @host_name_enabled=custom_host[0];
        @host_name= custom_host[1];
         

# Check if host_id is empty -- if not assign, if so, make it an empty string.
       if !host_id.empty?
          @host_id = host_id
          @host_id = "host_id=#{host_id}"
        else  
          @host_id=''
        end



#assign host_name, if no host name is given and host_name_enabled = true... assign a host_name based on the machine name.
       if @host_name_enabled
          if host_name.empty?
            @host_name=Socket.gethostname
          end

          @host_name="host_name=#{@host_name}"
        end


        @queue = Queue.new
	# Add identifer msg to queue to be sent first
        @queue << "#{@token}#{LIBRARY_IDENTIFIER}\n"
        @started = false
        @thread = nil

        if @debug
          self.init_debug
        end
        at_exit { shutdown! }
      end

      def init_debug
        filePath = "logentriesGem.log"
        if File.exist?('log/')
          filePath = "log/logentriesGem.log"
        end
        @debug_logger = Logger.new(filePath)
      end

      def dbg(message)
        if @debug
          @debug_logger.add(Logger::Severity::DEBUG, message)
        end
      end

      def write(message)

        if !host_id.empty? 
          message = "#{message} #{ host_id }"
        end

        if host_name_enabled
          message="#{message} #{ host_name }"
        end

        if @local
          @logger_console.add(Logger::Severity::UNKNOWN, message)
        end

        if message.scan(/\n/).empty?
          @queue << "#{ @token } #{ message } \n" 
        else
          @queue << "#{ message.gsub(/^/, "\1#{ @token } [#{ random_message_id }]") }\n"
        end


        if @started
          check_async_thread
        else
          start_async_thread
        end
      end

      def start_async_thread
        @thread = Thread.new { run() }
        dbg "LE: Asynchronous socket writer started"
        @started = true
      end

      def check_async_thread
        if not(@thread && @thread.alive?)
          @thread = Thread.new { run() }
        end
      end

      def close
        dbg "LE: Closing asynchronous socket writer"
        @started = false
      end

      def openConnection
        dbg "LE: Reopening connection to Logentries API server"
  

        if !@datahub_enabled
          port = @ssl ? API_SSL_PORT: API_PORT
          socket = TCPSocket.new(API_SERVER, port)      
        else  
          port = @datahub_port
          socket = TCPSocket.new(@datahub_ip, port)
        end

         
        if @ssl
          ssl_context = OpenSSL::SSL::SSLContext.new()
          ssl_context.cert = OpenSSL::X509::Certificate.new(API_CERT)
          ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
          ssl_socket.sync_close = true
          ssl_socket.connect
          @conn = ssl_socket
        else
          @conn = socket
        end
        dbg "LE: Connection established"
      end

      def reopenConnection
        closeConnection
        root_delay = 0.1
        loop do
          begin
            openConnection
            break
          rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError
            dbg "LE: Unable to connect to Logentries due to timeout(#{ $! })"
          rescue
            dbg "LE: Got exception in reopenConnection - #{ $! }"
            raise
          end
          root_delay *= 2
          if root_delay >= 10
            root_delay = 10
          end
          wait_for = (root_delay + rand(root_delay)).to_i
          dbg "LE: Waiting for #{ wait_for }ms"
          sleep(wait_for)
        end
      end

      def closeConnection
        begin
          if @conn.respond_to?(:sysclose)
            @conn.sysclose
          elsif @conn.respond_to?(:close)
            @conn.close
          end
        rescue
          dbg "LE: couldn't close connection, close with exception - #{ $! }"
        ensure
          @conn = nil
        end
      end

      def run
        reopenConnection

        loop do
          data = @queue.pop
          break if data == SHUTDOWN_COMMAND
          loop do
            begin
              @conn.write(data)
            rescue TimeoutError, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEOUT, EOFError
              dbg "LE: Connection timeout(#{ $! }), try to reopen connection"
              reopenConnection
              next
            rescue
              dbg("LE: Got exception in run loop - #{ $! }")
              raise
            end

            break
          end
        end

        dbg "LE: Closing Asyncrhonous socket writer"

        closeConnection
      end

      private
        def random_message_id
          @random_message_id_sample_space ||= ('0'..'9').to_a.concat(('A'..'Z').to_a)
          (0..5).map{ @random_message_id_sample_space.sample }.join
        end

        # at_exit handler.
        # Attempts to clear the queue and terminate the async worker cleanly before process ends.
        def shutdown!
          return unless @started
          dbg "LE: commencing shutdown, queue has #{queue.size} entries to clear"
          queue << SHUTDOWN_COMMAND
          SHUTDOWN_MAX_WAIT.div(SHUTDOWN_WAIT_STEP).times do
            break if queue.empty?
            sleep SHUTDOWN_WAIT_STEP
          end
          dbg "LE: shutdown complete, queue is #{queue.empty? ? '' : 'not '}empty with #{queue.size} entries"
        end

    end
  end
end
