require File.join(File.dirname(__FILE__), 'le', 'host')

require 'logger'

module Le

 def self.new(token, local=false, debug_level = Logger::DEBUG)

   self.checkParams(token)

   host = Le::Host.new(token, local)      
   logger = Logger.new(host)
   logger.level = debug_level
   
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
