require 'riak_odm/bucket'
require 'riak_odm/client'
require 'riak_odm/cluster'
require 'riak_odm/components'
require 'riak_odm/config'
require 'riak_odm/document'
require 'riak_odm/errors'
require 'riak_odm/finders'
require 'riak_odm/version'

module RiakOdm
  include Config

  def self.cluster
    if @cluster
      @cluster
    else
      raise if self.configuration.nil?
      @cluster = Cluster.new(self.configuration[:cluster])
    end
  end
end
