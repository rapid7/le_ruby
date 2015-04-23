module Le
  module Host

#!    def self.new(token, local, debug, ssl, datahub_enabled, datahub_ip, datahub_port, host_id, host_name_enabled, host_name)
    def self.new(token, local, debug, ssl, datahub_endpoint, host_id, custom_host, udp_port, local_shift_age, local_shift_size)

      Le::Host::HTTP.new(token, local, debug, ssl, datahub_endpoint, host_id, custom_host, udp_port, local_shift_age, local_shift_size)
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

        "severity=#{severity}, #{message_in.lstrip}"
      end
    end

  end
end

require File.join(File.dirname(__FILE__), 'host', 'http')
