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

  describe "when local is false" do
    specify { host.local.must_equal false }
    specify { logger_console.must_be_nil }
  end

  describe "when local is true" do
    let(:local)   { true }

    specify { host.local.must_equal true }
    specify { logger_console.must_be_instance_of Logger }

    describe "when non-Rails environment" do
      specify { logger_console_dev.must_be_instance_of IO }
    end

    describe "and Rails environment" do
      before do
        class Rails
          def self.root
            Pathname.new(File.dirname(__FILE__)).join('fixtures')
          end
          def self.env
            'test'
          end
        end
      end
      after do
        Object.send(:remove_const, :Rails)
      end
      specify { logger_console_dev.must_be_instance_of File }
    end

  end


end
