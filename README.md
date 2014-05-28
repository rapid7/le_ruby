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

If you want to local logging in addition to sending logs to logentries, just add local parameter after the key.
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

Now, simply use `Rails.logger.info("message")` inside your code to send logs to Logentries
