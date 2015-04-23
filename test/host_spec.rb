require 'spec_helper'

describe Le::Host do

  let(:token)   { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)   { false }
  let(:debug)   { false }
  let(:ssl)     { false }
  let(:udp_port){ nil }

  let(:datahub_endpoint) { ["", 10000] }
  let(:host_id) { ""}
  let(:custom_host)	{ [false, ""]}
  let(:local_shift_age) { 0 }
  let(:local_shift_size) { 100000 }

  #let(:host)    { Le::Host.new(token, local, debug, ssl) }
  let(:host)	{ Le::Host.new(token, local, debug, ssl, datahub_endpoint, host_id, custom_host, udp_port, local_shift_age, local_shift_size)}
  specify { host.must_be_instance_of Le::Host::HTTP }

end
