Logging to Logentries in Ruby
=============================

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
    
If you want to keep also the logs in the console and in the log file just add true after the key:

    Rails.logger = Le.new('LOGENTRIES_TOKEN', true)

You can also specify the default level of the logger by adding this :

    Rails.logger = Le.new('LOGENTRIES_TOKEN', true, Logger::<level>)

This will set the rails logger to use the Logentries logger in production and log to the console in development environment.

For the `LOGENTRIES_TOKEN` argument, paste the token for the logfile you created earlier in the Logentries UI.

Now, simply use `Rails.logger.info("message")` inside your code to send logs to Logentries
