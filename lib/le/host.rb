module Le
  module Host

    def self.new(token, local, debug, ssl, datahub_endpoint, host_id, custom_host, udp_port, use_data_endpoint)

      Le::Host::HTTP.new(token, local, debug, ssl, datahub_endpoint, host_id, custom_host, udp_port, use_data_endpoint)
    end

    module InstanceMethods
      def formatter
        proc do |severity, datetime, _, msg|
          message = "#{datetime} "
          message << format_message(msg, severity)
        end
      end

      def format_message(message_in, severity)
        message_in = message_in.inspect unless message_in.is_a?(String)

        "#{message_in.lstrip}"
      end
    end

  end
end

require File.join(File.dirname(__FILE__), 'host', 'http')
