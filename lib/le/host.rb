module Le
  module Host

    def self.new(token, local)
      Le::Host::HTTP.new(token, local)
    end

    module InstanceMethods
      def formatter
        proc do |severity, datetime, progname, msg|
          message = "#{datetime} "
          message << format_message(msg, severity)
        end
      end

      def format_message(message_in, severity)
        message_in = message_in.lstrip

        message_out = ""
        message_out = "severity=#{severity}, "
        case message_in
        when String
          message_out << message_in
        else
          message_out << message_in.inspect
        end
        message_out
      end
    end
  end
end

require File.join(File.dirname(__FILE__), 'host', 'http')
