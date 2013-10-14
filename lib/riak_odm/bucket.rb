module RiakOdm
  class Bucket
    # Initializes a new bucket object.
    #
    # @param cluster [RiakOdm::Cluster] the cluster in which the bucket resides.
    # @param bucket_name [String] the name of the cluster
    def initialize(cluster, bucket_name)
      @cluster = cluster
      @name = bucket_name
    end

    # Searches for a key in this bucket and returns an RpbFetchResp compatible class or hash.
    #
    # @param key [String] the key to search in the bucket.
    # @param options [Hash] see <tt>ProtocolBuffers::Client#fetch</tt>
    def find(key, options = {})
      result = @cluster.client.fetch options.merge(bucket: @name, key: key)
      if result.content.length == 0
        nil
      elsif result.content.length > 1
        # Resolve siblings... some way
      else
        result
      end
    end
  end
end