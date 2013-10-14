require 'configurability/config'

module RiakOdm
  module Config
    extend ActiveSupport::Concern

    module ClassMethods
      def load_configuration
        if Rails.root
          Configurability::Config.load(Rails.root.join('config/riak_odm.yml'))
        end
      end

      def configuration
        @@configuration ||= load_configuration
      end

      def configuration=(configuration)
        @@configuration = configuration
      end
    end
  end
end