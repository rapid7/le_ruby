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

    gem 'le', '1.9.1'

Then from the cmd line run the following command:

    bundle install

This will install the gem on your local environment.

The next step is to configure the default rails logger to use the logentries
logger.

In your `config/environment.rb` file, add the following:

- `Rails.logger = Le.new('LOGENTRIES_ACCOUNT_KEY', 'LOGENTRIES_LOCATION')`

This will set the rails logger to use the Logentries logger.

The first of the 2 arguments above is your account-key which you obtained
earlier from the Logentries UI.

The second is the file location which is the name of the host you set up
followed by the name of the log file in the format `hostname/logname`.

Local Logging
---------------
If you are running your app locally, you can add a third boolean parameter 'true'.

- `Rails.logger = Le.new('LOGENTRIES_ACCOUNT_KEY', 'LOGENTRIES_LOCATION', true)`

This will route the logs to the

console rather than Logentries. Be sure to set to false or remove when you are
deploying your app.

From anywhere in the views and controllers, the logger command can now be used
to log events. Also data on pages being opened and rendered will be forwarded
to your Logentries account.

