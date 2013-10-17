$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

MODELS = File.join(File.dirname(__FILE__), "app/models")
$LOAD_PATH.unshift(MODELS)

require 'riak_odm'
require 'rspec'

# Autoload test models
Dir[ File.join(MODELS, "*.rb") ].sort.each do |file|
  name = File.basename(file, ".rb")
  autoload name.camelize.to_sym, name
end

RiakOdm.configuration = { cluster: [
    { host: '127.0.0.1', port: 10017 }
]}

RSpec.configure do |config|
  config.before(:each) do
    RiakOdm::Client::ProtocolBuffers::Client.any_instance.stub(:initialize)
    RiakOdm::Client::ProtocolBuffers::Client.any_instance.stub(:send_message)
    RiakOdm::Client::ProtocolBuffers::Client.any_instance.stub(:receive_response).and_return nil
  end
end
