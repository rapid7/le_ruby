require 'spec_helper'

describe Le::Host do

  let(:token)   { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)   { false }
  let(:debug)   { false }
  let(:ssl)     { true }
  let(:udp_port){ nil }

  let(:datahub_endpoint) { ["", 10000] }
  let(:host_id) { ""}
  let(:custom_host)	{ [false, ""]}
  let(:data_endpoint) {true}

  #let(:host)    { Le::Host.new(token, local, debug, ssl) }
  let(:host)	{ Le::Host.new(token, local, debug, ssl, udp_port)}
  specify { host.must_be_instance_of Le::Host::HTTP }

end
