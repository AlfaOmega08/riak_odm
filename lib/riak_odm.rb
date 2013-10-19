# encoding: utf-8

require 'active_support/core_ext'
require 'active_support/json'
require 'active_support/inflector'
require 'active_support/time_with_zone'
require 'active_model'
require 'simple_uuid'

require 'riak_odm/attributes'
require 'riak_odm/bucket'
require 'riak_odm/client'
require 'riak_odm/cluster'
require 'riak_odm/components'
require 'riak_odm/config'
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

module RiakOdm
  include Config

  # Returns the cluster object that is used throughout the session.
  # When called for the first time, it will also connect to the Riak Cluster using configuration.
  def self.cluster
    if @cluster
      @cluster
    else
      raise if self.configuration.nil?
      @cluster = Cluster.new(self.configuration[:cluster])
    end
  end
end
