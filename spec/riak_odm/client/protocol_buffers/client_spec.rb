require 'spec_helper'
require 'socket'

describe RiakOdm::Client::ProtocolBuffers::Client do
  before(:each) do
    # Undo generic stubbing done in spec_helper.rb
    RiakOdm::Client::ProtocolBuffers::Client.any_instance.unstub(:initialize)
    RiakOdm::Client::ProtocolBuffers::Client.any_instance.unstub(:send_message)
    RiakOdm::Client::ProtocolBuffers::Client.any_instance.unstub(:receive_response)
  end

  describe '#initialize' do
    it 'calls #connect' do
      RiakOdm::Client::ProtocolBuffers::Client.any_instance.should_receive(:connect).exactly(3).and_return(false)

      expect {
        client = RiakOdm::Client::ProtocolBuffers::Client.new([
          { host: '127.0.0.1', port: 80 },
          { host: '192.168.1.123', port: 10018 },
          { host: '151.24.56.12', port: 7077 }
        ])
      }.to raise_error
    end

    it 'raises a RiakOdm::Errors::Connection when failing' do
      RiakOdm::Client::ProtocolBuffers::Client.any_instance.stub(:connect).and_return(false)

      expect {
        RiakOdm::Client::ProtocolBuffers::Client.new [ { host: '127.0.0.1', port: 80 } ]
      }.to raise_error(RiakOdm::Errors::Connection)

      RiakOdm::Client::ProtocolBuffers::Client.any_instance.unstub(:connect)
    end

    it 'does not raise when #connect is successful once' do
      RiakOdm::Client::ProtocolBuffers::Client.any_instance.stub(:connect).and_return(true)

      expect {
        RiakOdm::Client::ProtocolBuffers::Client.new [ { host: '127.0.0.1', port: 80 } ]
      }.to_not raise_error

      RiakOdm::Client::ProtocolBuffers::Client.any_instance.unstub(:connect)
    end
  end

  describe '#connect' do
    let(:client) { RiakOdm::Client::ProtocolBuffers::Client.allocate }

    it 'returns true when connection is established' do
      IO.stub(:select).and_return([[1], [1], []])
      expect(client.connect('127.0.0.1', 80)).to be_true
    end

    it 'returns false when connection is not estabilished' do
      IO.stub(:select).and_return(nil)
      expect(client.connect('127.0.0.1', 1)).to be_false
      Socket.any_instance.stub(:connect) do
        raise Errno::ECONNREFUSED
      end
      expect(client.connect('127.0.0.1', 1)).to be_false
    end
  end

  context 'When sending messages' do
    before(:all) do
      Socket.any_instance.stub(:connect).and_return(0)
    end

    let(:client) {
      RiakOdm::Client::ProtocolBuffers::Client.new [{ host: '127.0.0.1', port: 10017 }]
    }

    describe '#list_buckets' do
      it 'calls #send_message(LIST_BUCKETS_REQ)' do
        IO.stub(:select).and_return([[1], [1], []])

        client.should_receive(:send_message).with(RiakOdm::Client::ProtocolBuffers::Messages::LIST_BUCKETS_REQ)
        client.stub(:receive_response) do
          double("RpbListBucketsResp", buckets: [])
        end

        client.list_buckets
      end
    end
  end
end