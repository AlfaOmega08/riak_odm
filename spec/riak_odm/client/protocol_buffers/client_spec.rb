require 'spec_helper'
require 'socket'

describe RiakOdm::Client::ProtocolBuffers::Client do
  describe '#connect' do
    let(:client) { RiakOdm::Client::ProtocolBuffers::Client.allocate }

#    it 'sets a timeout when not nil' do
#      Socket.any_instance.stub(:connect).and_return(-1)
#      client.connect('127.0.0.1', 80)
#      client.connect('127.0.0.1', 80, 0.1)
#    end

    it 'does not send a timeout when nil or zero' do
      Socket.any_instance.stub(:connect).and_return(-1)
      Socket.any_instance.should_not_receive(:setsockopt)
      client.connect('127.0.0.1', 80, 0.0)
      client.connect('127.0.0.1', 80, nil)
    end

    it 'returns true when connection is established' do
      Socket.any_instance.stub(:connect).and_return(0)
      expect(client.connect('127.0.0.1', 80)).to be_true
    end

    it 'returns false when connection is not estabilished' do
      Socket.any_instance.stub(:connect).and_return(-1)
      expect(client.connect('127.0.0.1', 1)).to be_false
    end
  end
end