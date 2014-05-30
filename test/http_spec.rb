require 'spec_helper'
require 'pathname'

describe Le::Host::HTTP do

  let(:token)              { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)              { false }
  let(:debug)              { false }
  let(:ssl)                { false }
  let(:host)               { Le::Host::HTTP.new(token, local, debug, ssl) }
  let(:logger_console)     { host.instance_variable_get(:@logger_console) }
  let(:logger_console_dev) { logger_console.instance_variable_get(:@logdev).dev }

  specify { host.must_be_instance_of Le::Host::HTTP }
  specify { host.local.must_equal false }
  specify { host.debug.must_equal false }
  specify { host.ssl.must_equal false }

end
