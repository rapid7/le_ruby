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
created your account, you must obtain the user-key for your account, which
allows the gem to access your account on the server.

To obtain your user-key simply run the getKey.rb script with the argument
`--key`, e.g
    `ruby getKey.rb --key`

You will be asked for your login credentials which you registered on the
website and it will print your user-key.

This user-key which is essentially a password to the system is required in the
steps below to use this gem - keep this safe as you will need it in a few
moments.

A host must be created on Logentries as well as a file in that host to store
your logs in, these can be created either using the Logentries user interface
or with the getKey.rb script.

To use the getKey.rb script, the command is as follows:
    `ruby getKey.rb --register`

This will prompt you for your user-key and then set up the default settings
(recommended) which are:   Host: Heroku Log: Heroku.log

You can choose a name for both the Host and the log file yourself with the
`getKey.rb` script.

Simply type (parameters `-h` and `-l` are both optional)

    ruby getType.rb --register -h HOSTNAME* -l LOGNAME* 

At any time you can type `ruby getType.rb --help` for a more detailed usage.

Now you are setup to send logs to the Logentries server.

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

The first of the 2 arguments above is your user-key that you obtained using
`getKey.rb` 

The second is the name of the host you set up followed by the name of the log
file. 

If you used the default settings by running `ruby getKey.rb --register`, then
`Heroku/Heroku.log` is the correct parameter here.

From anywhere in the views and controllers, the logger command can now be used
to log events. Also data on pages being opened and rendered will be forwarded
to your Logentries account.

