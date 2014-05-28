require 'spec_helper'

describe Le::Host do

  let(:token)   { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)   { false }
  let(:debug)   { false }
  let(:ssl)     { false }
  let(:host)    { Le::Host.new(token, local, debug, ssl) }

  specify { host.must_be_instance_of Le::Host::HTTP }

end
