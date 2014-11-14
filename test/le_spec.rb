require 'spec_helper'

describe Le do

  let(:token)              { '11111111-2222-3333-aaaa-bbbbbbbbbbbb' }
  let(:local)              { false }
  let(:logger)             { Le.new(token, local: local) }
  let(:logdev)             { logger.instance_variable_get(:@logdev).dev }
  let(:logger_console)     { logdev.instance_variable_get(:@logger_console) }
  let(:logger_console_dev) { logger_console.instance_variable_get(:@logdev).dev }


  describe "when non-Rails environment" do

    describe "when initialised with just a token" do
      let(:logger)         { Le.new(token) }
      specify { logger.must_be_instance_of Logger }
      specify { logdev.must_be_instance_of Le::Host::HTTP }
      specify { logdev.local.must_equal false }
      specify { logger_console.must_be_nil }
    end

    describe "and :local is false" do
      specify { logdev.local.must_equal false }
      specify { logger_console.must_be_nil }
    end

    describe "and :local is true" do
      let(:local)   { true }

      specify { logdev.local.must_equal true }
      specify { logger_console.must_be_instance_of Logger }
      specify { logger_console_dev.must_be_instance_of IO }
    end


    describe "and :local => " do
      let(:local_test_log) { Pathname.new(File.dirname(__FILE__)).join('fixtures','log','local_log.log') }
      let(:local)   { log_file }

      describe "Pathname" do
        let(:log_file) { local_test_log }

        specify { logdev.must_be_instance_of Le::Host::HTTP }
        specify { logdev.local.must_equal true }
        specify { logger_console.must_be_instance_of Logger }
        specify { logger_console_dev.must_be_instance_of File }
        specify { logger_console_dev.path.must_match 'local_log.log' }
      end

      describe "path string" do
        let(:log_file) { local_test_log.to_s }

        specify { logdev.must_be_instance_of Le::Host::HTTP }
        specify { logdev.local.must_equal true }
        specify { logger_console.must_be_instance_of Logger }
        specify { logger_console_dev.must_be_instance_of File }
        specify { logger_console_dev.path.must_match 'local_log.log' }
      end

      describe "File" do
        let(:log_file) { File.new(local_test_log, 'w') }

        specify { logdev.must_be_instance_of Le::Host::HTTP }
        specify { logdev.local.must_equal true }
        specify { logger_console.must_be_instance_of Logger }
        specify { logger_console_dev.must_be_instance_of File }
        specify { logger_console_dev.path.must_match 'local_log.log' }
      end

    end

  end

  describe "when Rails environment" do
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

    describe "and :local is false" do
      specify { logdev.local.must_equal false }
      specify { logger_console.must_be_nil }
    end

    describe "and :local is true" do
      let(:local)   { true }

      specify { logdev.local.must_equal true }
      specify { logger_console.must_be_instance_of Logger }
      specify { logger_console_dev.must_be_instance_of File }
      specify { logger_console_dev.path.must_match 'test.log' }
    end

    describe "and :local => " do
      let(:local_test_log) { Pathname.new(File.dirname(__FILE__)).join('fixtures','log','local_log.log') }
      let(:local)   { log_file }

      describe "Pathname" do
        let(:log_file) { local_test_log }

        specify { logdev.must_be_instance_of Le::Host::HTTP }
        specify { logdev.local.must_equal true }
        specify { logger_console.must_be_instance_of Logger }
        specify { logger_console_dev.must_be_instance_of File }
        specify { logger_console_dev.path.must_match 'local_log.log' }
      end

      describe "path string" do
        let(:log_file) { local_test_log.to_s }

        specify { logdev.must_be_instance_of Le::Host::HTTP }
        specify { logdev.local.must_equal true }
        specify { logger_console.must_be_instance_of Logger }
        specify { logger_console_dev.must_be_instance_of File }
        specify { logger_console_dev.path.must_match 'local_log.log' }
      end

      describe "File" do
        let(:log_file) { File.new(local_test_log, 'w') }

        specify { logdev.must_be_instance_of Le::Host::HTTP }
        specify { logdev.local.must_equal true }
        specify { logger_console.must_be_instance_of Logger }
        specify { logger_console_dev.must_be_instance_of File }
        specify { logger_console_dev.path.must_match 'local_log.log' }
      end

    end

  end

end
