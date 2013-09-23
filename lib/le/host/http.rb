require 'socket'
require 'openssl'
require 'thread'
require 'uri'

module Le
  module Host
    class HTTP
      API_SERVER = 'api.logentries.com'
      API_PORT = 10000
      API_SSL_PORT = 20000
      API_CERT = '-----BEGIN CERTIFICATE-----
MIIFSjCCBDKgAwIBAgIDBQMSMA0GCSqGSIb3DQEBBQUAMGExCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMR0wGwYDVQQLExREb21haW4gVmFsaWRh
dGVkIFNTTDEbMBkGA1UEAxMSR2VvVHJ1c3QgRFYgU1NMIENBMB4XDTEyMDkxMDE5
NTI1N1oXDTE2MDkxMTIxMjgyOFowgcExKTAnBgNVBAUTIEpxd2ViV3RxdzZNblVM
ek1pSzNiL21hdktiWjd4bEdjMRMwEQYDVQQLEwpHVDAzOTM4NjcwMTEwLwYDVQQL
EyhTZWUgd3d3Lmdlb3RydXN0LmNvbS9yZXNvdXJjZXMvY3BzIChjKTEyMS8wLQYD
VQQLEyZEb21haW4gQ29udHJvbCBWYWxpZGF0ZWQgLSBRdWlja1NTTChSKTEbMBkG
A1UEAxMSYXBpLmxvZ2VudHJpZXMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxcmFqgE2p6+N9lM2GJhe8bNUO0qmcw8oHUVrsneeVA66hj+qKPoJ
AhGKxC0K9JFMyIzgPu6FvuVLahFZwv2wkbjXKZLIOAC4o6tuVb4oOOUBrmpvzGtL
kKVN+sip1U7tlInGjtCfTMWNiwC4G9+GvJ7xORgDpaAZJUmK+4pAfG8j6raWgPGl
JXo2hRtOUwmBBkCPqCZQ1mRETDT6tBuSAoLE1UMlxWvMtXCUzeV78H+2YrIDxn/W
xd+eEvGTSXRb/Q2YQBMqv8QpAlarcda3WMWj8pkS38awyBM47GddwVYBn5ZLEu/P
DiRQGSmLQyFuk5GUdApSyFETPL6p9MfV4wIDAQABo4IBqDCCAaQwHwYDVR0jBBgw
FoAUjPTZkwpHvACgSs5LdW6gtrCyfvwwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQW
MBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHREEFjAUghJhcGkubG9nZW50cmll
cy5jb20wQQYDVR0fBDowODA2oDSgMoYwaHR0cDovL2d0c3NsZHYtY3JsLmdlb3Ry
dXN0LmNvbS9jcmxzL2d0c3NsZHYuY3JsMB0GA1UdDgQWBBRaMeKDGSFaz8Kvj+To
j7eMOtT/zTAMBgNVHRMBAf8EAjAAMHUGCCsGAQUFBwEBBGkwZzAsBggrBgEFBQcw
AYYgaHR0cDovL2d0c3NsZHYtb2NzcC5nZW90cnVzdC5jb20wNwYIKwYBBQUHMAKG
K2h0dHA6Ly9ndHNzbGR2LWFpYS5nZW90cnVzdC5jb20vZ3Rzc2xkdi5jcnQwTAYD
VR0gBEUwQzBBBgpghkgBhvhFAQc2MDMwMQYIKwYBBQUHAgEWJWh0dHA6Ly93d3cu
Z2VvdHJ1c3QuY29tL3Jlc291cmNlcy9jcHMwDQYJKoZIhvcNAQEFBQADggEBAAo0
rOkIeIDrhDYN8o95+6Y0QhVCbcP2GcoeTWu+ejC6I9gVzPFcwdY6Dj+T8q9I1WeS
VeVMNtwJt26XXGAk1UY9QOklTH3koA99oNY3ARcpqG/QwYcwaLbFrB1/JkCGcK1+
Ag3GE3dIzAGfRXq8fC9SrKia+PCdDgNIAFqe+kpa685voTTJ9xXvNh7oDoVM2aip
v1xy+6OfZyGudXhXag82LOfiUgU7hp+RfyUG2KXhIRzhMtDOHpyBjGnVLB0bGYcC
566Nbe7Alh38TT7upl/O5lA29EoSkngtUWhUnzyqYmEMpay8yZIV4R9AuUk2Y4HB
kAuBvDPPm+C0/M4RLYs=
-----END CERTIFICATE-----'

      include Le::Host::InstanceMethods
      attr_accessor :token, :queue, :started, :thread, :conn, :local, :debug, :ssl

      def initialize(token, local, debug, ssl)
        if local
          if defined?(Rails)
            @logger_console = Logger.new("log/#{Rails.env}.log")
          else
            @logger_console = Logger.new(STDOUT)
          end
        end
        @token = token
        @local = local
        @debug = debug
        @ssl = ssl
        @queue = Queue.new
        @started = false
        @thread = nil

        if @debug
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
        if @debug
          @debug_logger.add(Logger::Severity::DEBUG, message)
        end
      end

      def write(message)
        if @local
          @logger_console.add(Logger::Severity::UNKNOWN, message)
        end

        @queue << "#{ @token }#{ message }\n"

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
        port = @ssl ? API_SSL_PORT : API_PORT
        socket = TCPSocket.new(API_SERVER, port)
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
    end
  end
end
