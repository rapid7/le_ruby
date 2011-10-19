Logging to Logentries in Ruby
=============================

This is a Logentries library for logging from Ruby platforms, including Heroku.

It is available on github <https://github.com/logentries/le_ruby> and rubygems
<http://rubygems.org/>.


Example
-------

    Rails.logger.info("information message")
    Rails.logger.warn("warning message")
    Rails.logger.debug("debug message")


Howto
-----

You must first register your account details with Logentries.  Once you have
created your account, you must obtain the account-key for your account, which
allows the gem to access your account on the server.

This is obtained by clicking Account in the top left corner of the Logentries UI and display account-key on the right.

You will use this account-key in a few minutes to configure the gem with your Logentries account.

A host must be created on Logentries as well as a file in that host to store
your logs in, these can be created either using the Logentries UI
or with a ruby script.

To use the ruby script, download the following:   https://github.com/logentries/le_ruby/raw/master/getKey.rb
    
Run the following command    `ruby getKey.rb --register`

This will prompt you for your Logentries login credentials and create the following default host and log.
   Host: Heroku Log: Heroku.log

Now you are set up to send logs to the Logentries server.

Heroku
------

To install the gem you must edit the Gemfile in your local heroku environment

Add the following line:

    gem 'le', '1.6'

Then from the cmd line run the following command:

    bundle install

This will install the gem on your local environment.

On the next push to Heroku, the gem will automatically be downloaded to heroku
server as it is included in the Gemfile.

The next step is to configure the default rails logger to use the logentries
logger.

Pending which rails logger you wish to use, in your `config/environment.rb`
file, add either of the following:

- `ActionController::Base.logger = Le.new('userkey', 'Heroku/Heroku.log')`
- `ActiveRecord::Base.logger = Le.new('userkey', 'Heroku/Heroku.log')`
- `Rails.logger = Le.new('userkey', 'Heroku/Heroku.log')`

This will set the appropriate rails logger to use the logentries logger.

The first of the 2 arguments above is your account-key which you obtained earlier 
from the Logentries UI.

The second is the name of the host you set up followed by the name of the log
file in the format  `hostname/logname`

If you used the default settings by running `ruby getKey.rb --register`, then
`Heroku/Heroku.log` is the correct parameter here.

From anywhere in the views and controllers, the logger command can now be used
to log events. Also data on pages being opened and rendered will be forwarded
to your Logentries account.

