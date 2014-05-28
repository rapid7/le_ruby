require 'spec_helper'

describe Le do

  let(:token)              { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)              { false }
  let(:debug)              { false }
  let(:ssl)                { false }
  let(:logger)             { Le.new(token) }
  let(:logdev)             { logger.instance_variable_get(:@logdev).dev }
  let(:logger_console)     { logdev.instance_variable_get(:@logger_console) }
  let(:logger_console_dev) { logger_console.instance_variable_get(:@logdev).dev }

  describe "when initialised with just a token" do
    specify { logger.must_be_instance_of Logger }
    specify { logdev.must_be_instance_of Le::Host::HTTP }
    specify { logdev.local.must_equal false }
    specify { logger_console.must_be_nil }
  end

  describe "when initialised with :local => true" do
    let(:logger)  { Le.new(token, local: true) }

    specify { logdev.must_be_instance_of Le::Host::HTTP }
    specify { logdev.local.must_equal true }
    specify { logger_console.must_be_instance_of Logger }
    specify { logger_console_dev.must_be_instance_of IO }
  end

  describe "when initialised with :local" do
    let(:local_test_log) { Pathname.new(File.dirname(__FILE__)).join('fixtures','log','local_log.log') }
    let(:logger)         { Le.new(token, local: log_file) }

    describe " => Pathname" do
      let(:log_file) { local_test_log }

      specify { logdev.must_be_instance_of Le::Host::HTTP }
      specify { logdev.local.must_equal true }
      specify { logger_console.must_be_instance_of Logger }
      specify { logger_console_dev.must_be_instance_of File }
    end
    describe " => path string" do
      let(:log_file) { local_test_log.to_s }

      specify { logdev.must_be_instance_of Le::Host::HTTP }
      specify { logdev.local.must_equal true }
      specify { logger_console.must_be_instance_of Logger }
      specify { logger_console_dev.must_be_instance_of File }
    end
    describe " => File" do
      let(:log_file) { File.new(local_test_log) }

      specify { logdev.must_be_instance_of Le::Host::HTTP }
      specify { logdev.local.must_equal true }
      specify { logger_console.must_be_instance_of Logger }
      specify { logger_console_dev.must_be_instance_of File }
    end

  end

end
