require 'spec_helper'
require 'pathname'

describe Le::Host::HTTP do

  let(:token)   { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)   { false }
  let(:debug)   { false }
  let(:ssl)     { false }
  let(:host)    { Le::Host::HTTP.new(token, local, debug, ssl) }
  subject       { host }

  it { subject.must_be_instance_of Le::Host::HTTP }

  describe "when local is false" do
    it { subject.local.must_equal false }
    it { subject.instance_variable_get(:@logger_console).must_be_nil }
  end

  describe "when local is true" do
    let(:local)   { true }
    let(:logger_console) { host.instance_variable_get(:@logger_console) }

    it { subject.local.must_equal true }
    it { logger_console.must_be_instance_of Logger }

    describe "when non-Rails environment" do
      it { logger_console.instance_variable_get(:@logdev).dev.must_be_instance_of IO }
    end

  end


end
