Logging to Logentries in Ruby
=============================

[![Build Status](https://travis-ci.org/rapid7/le_ruby.svg?branch=master)](https://travis-ci.org/rapid7/le_ruby)
This is a Logentries library for logging from Ruby platforms, including Heroku.

It is available on github <https://github.com/rapid7/le_ruby/> and rubygems
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
Inside this host, create a new logfile, selecting `Token TCP` (or `Plain TCP/UDP` if using UDP)
as the source type.

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

For the `LOGENTRIES_TOKEN` argument, paste the token for the logfile you created earlier in the Logentries UI or empty string for
a UDP connection. Additionally, when connecting via UDP, be sure to specify a port using the udp_port parameter:

    Rails.logger = Le.new('', :udp_port => 13287)

Users have the option of using `data.logentries.com` which uses ports 80 and 443 for insecure and secure connections respectively.
    
    Rails.logger = Le.new('', :data_endpoint => true)



Step for setting up DataHub
---------------------------

**datahub_endpoint - User Defined Array**

datahub_endpoint = Array ["127.0.0.1", "10000"]  
datahub_endpoint is a user defined variable array for a datahub_endpoint
The 1st parameter is a String which is the DataHub Instance's IP Address.  Entering ANY value in this field will disable your Token-based
logging, set your Token to "" and will direct all log events to your specified DataHub IP Address.

The 2nd parameter is a String which is the DataHub Port value, default is 10000 but this can be changed on your DataHub Machine.
This port number must be set, on your DataHub Machine's leproxy settings your /etc/leproxy/leproxyLocal.config file.  It's default is 10000
NOTE: if datahub_endpoint has been assigned an IP address and SSL = true, your server will fail gracefully.
When using Datahub do not enable SSL = true  


**host_id**

host_id = "abc1234"  
Enter_host_id inside the quotation marks.  Leaving this empty leave the host_id empty and thus not appear in your log events.


**custom_host_name - User Defined Array**

custom_host = Array[ true, "mikes_app_server"]
The 1st parameter is a Boolean value to use the custom host name.
The 2nd parameter is a String which is the custom_host_name you'd like to assign.  

If the 2nd parameter is left as in custom_host = Array[ true, ""] the code will attempt to get your host machine's name using the socket.gethostname method.



Using the above user defined variable settings, you can now also specify the several of the optional arguments for the logger constructor by adding:

    Rails.logger = Le.new(token, :ssl=>ssl, :datahub_endpoint=>datahub_endpoint, :host_id=>host_id, :custom_host=>custom_host)


Now, simply use `Rails.logger.info("message")` inside your code to send logs to Logentries
