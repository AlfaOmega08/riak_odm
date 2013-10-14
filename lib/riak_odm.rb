require 'riak_odm/bucket'
require 'riak_odm/client'
require 'riak_odm/cluster'
require 'riak_odm/components'
require 'riak_odm/document'
require 'riak_odm/errors'
require 'riak_odm/finders'
require 'riak_odm/version'

module RiakOdm
  class << self
    def cluster
      @cluster ||= Cluster.new([])
    end
  end
end
