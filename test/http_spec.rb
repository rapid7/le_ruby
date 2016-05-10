require 'spec_helper'
require 'pathname'

describe Le::Host::HTTP do

  let(:token)              { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)              { false }
  let(:debug)              { false }
  let(:ssl)                { false }
  let(:udp)                { nil }

  let(:datahub_endpoint)  { ["", 10000]}
  let(:host_id)           {""}
  let(:custom_host)       {[false, ""]}
  let(:endpoint)       {false}



#  let(:host)               { Le::Host::HTTP.new(token, local, debug, ssl) }
  let(:host)               { Le::Host::HTTP.new(token, local, debug, ssl, datahub_endpoint, host_id, custom_host, udp, endpoint) }

  let(:logger_console)     { host.instance_variable_get(:@logger_console) }
  let(:logger_console_dev) { logger_console.instance_variable_get(:@logdev).dev }

  specify { host.must_be_instance_of Le::Host::HTTP }
  specify { host.local.must_equal false }
  specify { host.debug.must_equal false }
  specify { host.ssl.must_equal false }
  specify { host.udp_port.must_equal nil }
  specify {host_id.must_equal ""}
  specify {custom_host.must_equal [false, ""]}

end
