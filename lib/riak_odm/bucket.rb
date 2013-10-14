module RiakOdm
  class Bucket
    def initialize(cluster, bucket_name)
      @cluster = cluster
      @name = bucket_name
    end

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