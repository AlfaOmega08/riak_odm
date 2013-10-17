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

    # Returns all the keys in the bucket.
    # @warning This method should never be called in production environments, in front of normal users.
    #   It is one of the slowest operations that Riak can execute, and all of the Cluster will receive an usage peak.
    def all_keys
      @cluster.client.list_keys(@name)
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

    def find_by(index, value_or_range, options = {})
      my_options = { bucket: @name, index: index }
      if value_or_range.is_a? Array
        my_options[:range_min] = value_or_range[0]
        my_options[:range_max] = value_or_range[1]
        my_options[:qtype] = RiakOdm::Client::ProtocolBuffers::Messages::RpbIndexReq::IndexQueryType::Range
      else
        my_options[:key] = value_or_range
        my_options[:qtype] = RiakOdm::Client::ProtocolBuffers::Messages::RpbIndexReq::IndexQueryType::Eq
      end

      @cluster.client.index_search options.merge(my_options)
    end

    def store(key, content, indexes = {}, meta = {}, options = {})
      meta = meta.map { |key, value| { key: key, value: value} }
      indexes = meta.map { |key, value| { key: key, value: value} }

      my_options = { bucket: @name, key: key }
      rbpcontent = RiakOdm::Client::ProtocolBuffers::Messages::RpbContent.new({
          value: content,
          content_type: options.delete(:content_type),
          usermeta: meta,
          indexes: indexes
      })

      my_options[:content] = rbpcontent

      begin
        @cluster.client.store options.merge(my_options)
      rescue RiakOdm::Errors::ServerError

      end
    end

    def destroy(key)
      @cluster.client.delete({ bucket: @name, key: key })
    end
  end
end