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

You must first register your account details with Logentries. Once you have
created your account, you must obtain the account-key for your account, which
allows the gem to access your account on the server.

This is obtained by clicking Account in the top left corner of the Logentries
UI and the account-key is displayed in grey on the right.

You will use this account-key in a few minutes to configure the gem with your
Logentries account.

A host must be created on Logentries as well as a file in that host to store
your logs in, these can be created using the Logentries UI.

Heroku
------

To install the gem you must edit the Gemfile in your local heroku environment

Add the following line:

    gem 'le', '1.9.2'

Then from the cmd line run the following command:

    bundle install

This will install the gem on your local environment.

The next step is to configure the default rails logger to use the logentries
logger.

In your `config/environment.rb` file, add the following:

    `if Rails.env.development?
        Rails.logger = Le.new('LOGENTRIES_ACCOUNT_KEY', 'LOGENTRIES_LOCATION', true)
    else
        Rails.logger = Le.new('LOGENTRIES_ACCOUNT_KEY', 'LOGENTRIES_LOCATION')
    end`

This will set the rails logger to use the Logentries logger in production and log to the console in development environment.

The first of the 2 arguments above is your account-key which you obtained
earlier from the Logentries UI.

The second is the file location which is the name of the host you set up
followed by the name of the log file in the format `hostname/logname`.

Now, simply use Rails.logger.info("message") inside your code to send logs to Logentries
