# encoding: utf-8

require 'active_support/all'
require 'active_model'
require 'simple_uuid'
require 'configurability'

require 'riak_odm/associations'
require 'riak_odm/attributes'
require 'riak_odm/bucket'
require 'riak_odm/client'
require 'riak_odm/cluster'
require 'riak_odm/components'
require 'riak_odm/criteria'
require 'riak_odm/destroyable'
require 'riak_odm/document'
require 'riak_odm/errors'
require 'riak_odm/field'
require 'riak_odm/fields'
require 'riak_odm/finders'
require 'riak_odm/index'
require 'riak_odm/indexes'
require 'riak_odm/persistence'
require 'riak_odm/version'

if defined?(Rails)
  require 'riak_odm/railtie'
end

module RiakOdm
  mattr_accessor :configuration

  include Config

  # Returns the cluster object that is used throughout the session.
  # When called for the first time, it will also connect to the Riak Cluster using configuration.
  def self.cluster
    @cluster ||= unless self.configuration
                   raise
                 else
                   Cluster.new(self.configuration[:cluster])
                 end
  end

  def self.load!(file)
    self.configuration = Configurability::Config.load(Rails.root.join(file))
  end
end
