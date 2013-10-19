require 'riak_odm'
require 'rails'

module Rails
  module RiakOdm
    class Railtie < Rails::Railtie
      def self.rescue_responses
        {
            "RiakOdm::Errors::DocumentNotFound" => :not_found
        }
      end

      if config.action_dispatch.rescue_responses
        config.action_dispatch.rescue_responses.merge!(rescue_responses)
      end

      initializer "riak_odm.load-config" do
        config_file = Rails.root.join("config", "riak_odm.yml")
        if config_file.file?
          ::RiakOdm.load!(config_file)
        end
      end
    end
  end
end