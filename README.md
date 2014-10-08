Logging to Logentries in Ruby
=============================

[![Build Status](https://travis-ci.org/logentries/le_ruby.svg?branch=master)](https://travis-ci.org/m0wfo/le_ruby)

This is a Logentries library for logging from Ruby platforms, including Heroku.

It is available on github <https://github.com/logentries/le_ruby/> and rubygems
<http://rubygems.org/>.


Example
-------

    Rails.logger.info("information message")
    Rails.logger.warn("warning message")
    Rails.logger.debug("debug message")


Howto
-----

You must first register your account details with Logentries.

Once you have logged in to Logentries, create a new host with a name of your choice.
Inside this host, create a new logfile, selecting `Token TCP` as the source type.

Heroku
------

To install the gem you must edit the Gemfile in your local heroku environment

Add the following line:

    gem 'le'

Then from the cmd line run the following command:

    bundle install

This will install the gem on your local environment.

The next step is to configure the default rails logger to use the logentries
logger.  


In your environment configuration file ( for production : `config/environments/production.rb`), add the following:

    Rails.logger = Le.new('LOGENTRIES_TOKEN')

If you want to keep logging locally in addition to sending logs to logentries, just add local parameter after the key.
By default, this will write to the standard Rails log or to STDOUT if not using Rails:

    Rails.logger = Le.new('LOGENTRIES_TOKEN', :local => true)

You may specify the local log device by providing a filename (String) or IO object (typically STDOUT, STDERR, or an open file):

    Rails.logger = Le.new('LOGENTRIES_TOKEN', :local => 'log/my_custom_log.log')

If you want the gem to use SSL when streaming logs to Logentries, add the ssl parameter and set it to true:

    Rails.logger = Le.new('LOGENTRIES_TOKEN', :ssl => true)

If you want to print debug messages for the gem to a file called logentriesGem.log, add this:

	Rails.logger = Le.new('LOGENTRIES_TOKEN', :debug => true)

If you want to use ActiveSupport::TaggedLogging logging, add this:

    Rails.logger = Le.new('LOGENTRIES_TOKEN', :tag => true)

You can also specify the default level of the logger by adding a :

    Rails.logger = Le.new('LOGENTRIES_TOKEN', :log_level => Logger::<level>)

For the `LOGENTRIES_TOKEN` argument, paste the token for the logfile you created earlier in the Logentries UI.

DataHub Logging 

Enter user defined variables in your environment.rb file

#### USER DEFINED VARIALBES #####

token = ''      # 'insert_token_here_inside_these_quotation_marks'
ssl = false
datahub_endpoint = Array ["", "10000"]  
host_id = ""  
custom_host = Array[ false, ""]
### END USER DEFINED VARIABLES ###         

DATAHUB_ENDPOINT USER-DEFINED ARRAY

datahub_endpoint = Array ["", "10000"]  
datahub_endpoint is a user defined variable array for a datahub_endpoint
The 1st parameter is a String which is the DataHub Instance's IP Address.  Entering ANY value in this field will disable your Token-based
logging, set your Token to "" and will direct all log events to your specified DataHub IP Address.

The 2nd parameter is a String which is the DataHub Port value, default is 10000 but this can be changed on your DataHub Instanc
This port number must be set, on your DataHub Machine's leproxy settings your /etc/leproxy/leproxyLocal.config file.
NOTE: if datahub_endpoint has been assigned an IP address and SSL = true, your server will fail gracefully.
When using Datahub do not enable SSL = true  


HOST_ID 
host_id = ""  
Enter_host_id inside the quotation marks.  Leaving this empty leave the host_id empty and thus not appear in your log events.


CUSTOM_HOST NAME - USER-DEFINED ARRAY 
custom_host = Array[ false, ""]         
The 1st parameter is a Boolean value to use the custom host name.
The 2nd parameter is a String which is the custom_host_name you'd like to assign.  

If the 2nd parameter is left as "" and the Boolean value is true, the code will attempt to get your host machine's name using
the socket.gethostname method.



Using the above settings, you can now also specify the several of the optional settings of the logger by adding:

    Rails.logger = Le.new(token, :ssl=>ssl, :datahub_endpoint=>datahub_endpoint, :host_id=>host_id, :custom_host=>custom_host)


Now, simply use `Rails.logger.info("message")` inside your code to send logs to Logentries
