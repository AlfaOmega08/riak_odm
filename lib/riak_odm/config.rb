require 'configurability/config'

module RiakOdm
  module Config
    extend ActiveSupport::Concern

    module ClassMethods
      # Loads the configuration from the <tt>config/riak_odm.yml</tt> YAML file, in case of Rails Application.
      def load_configuration
        if defined?(Rails)
          Configurability::Config.load(Rails.root.join('config/riak_odm.yml'))
        end
      end

      # Returns the configuration hash. It loads from a configuration file if nil.
      def configuration
        @@configuration ||= load_configuration
      end

      # Sets the configuration hash.
      def configuration=(configuration)
        @@configuration = configuration
      end
    end
  end
end