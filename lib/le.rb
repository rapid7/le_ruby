require File.join(File.dirname(__FILE__), 'le', 'host')

require 'logger'

module Le

 def self.new(token, options={})

   self.checkParams(token)

   opt_local = options[:local] || false
   opt_debug = options[:debug] || false
   opt_log_level = options[:log_level] || Logger::DEBUG

   host = Le::Host.new(token, opt_local, opt_debug)      
   logger = Logger.new(host)

   logger.level = opt_log_level
   
   if host.respond_to?(:formatter)
	logger.formatter = host.formatter
   end

   logger  
 end

 def self.checkParams(token)
    # Check if the key is valid UUID format
    if (token =~ /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i) == nil
       puts "\nLE: It appears the LOGENTRIES_TOKEN you entered is invalid!\n"
    end
 end
end
