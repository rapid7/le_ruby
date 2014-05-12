require 'spec_helper'

describe Le do

  let(:token)   { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:logger)  { Le.new(token) }
  subject       { logger }

  it { subject.must_be_instance_of Logger }
  it { subject.instance_variable_get(:@logdev).dev.must_be_instance_of Le::Host::HTTP }

end
