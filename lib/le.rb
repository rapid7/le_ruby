require File.join(File.dirname(__FILE__), 'le', 'host')

require 'logger'

module Le

  def self.new(token, options={})

    opt_local     = options[:local]                     || false
    opt_debug     = options[:debug]                     || false
    opt_ssl       = options[:ssl]                       || false
    opt_tag       = options[:tag]                       || false
    opt_log_level = options[:log_level]                 || Logger::DEBUG
    opt_local_shift_age = options[:local_shift_age]     || 0
    opt_local_shift_size = options[:local_shift_size]   || 1048576

    opt_datahub_enabled = options[:datahub_enabled]     || false
    opt_datahub_endpoint = options[:datahub_endpoint]   || ['', 10000]
    opt_datahub_ip = options[:datahub_ip]               || ''
    opt_datahub_port    = options[:datahub_port]        || 10000
    opt_host_id = options[:host_id] || ''
    opt_host_name_enabled = options[:host_name_enabled] || false
    opt_host_name = options[:host_name]                 || ''
    opt_custom_host = options[:custom_host]             || [false, '']

    opt_udp_port = options[:udp_port]                   || nil

    self.checkParams(token, opt_datahub_enabled, opt_udp_port)


    host = Le::Host.new(token, opt_local, opt_debug, opt_ssl, opt_datahub_endpoint, opt_host_id, opt_custom_host, opt_udp_port, opt_local_shift_age, opt_local_shift_size)

    if defined?(ActiveSupport::TaggedLogging) &&  opt_tag
      logger = ActiveSupport::TaggedLogging.new(Logger.new(host))
    elsif defined?(ActiveSupport::Logger)
      logger = ActiveSupport::Logger.new(host)
      logger.formatter = host.formatter if host.respond_to?(:formatter)
    else
      logger = Logger.new(host, opt_local_shift_age,opt_local_shift_size)
      logger.formatter = host.formatter if host.respond_to?(:formatter)
    end

    logger.level = opt_log_level

    logger
  end

  def self.checkParams(token, opt_datahub_enabled, opt_udp_port)
    # Check if the key is valid UUID format

    if (!opt_datahub_enabled && !opt_udp_port)  # test Token only when DataHub and UDP are not enabled
      if (token =~ /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i) == nil
         puts "\nLE: It appears the LOGENTRIES_TOKEN you entered is invalid!\n"
      else
        (token="")
     end
   end
  end

end
