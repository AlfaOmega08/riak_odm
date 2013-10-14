module RiakOdm
  class Cluster
    def initialize(servers, use_http = false)
      if use_http
        @client = RiakOdm::Client::Http::Client.new(servers)
      else
        @client = RiakOdm::Client::ProtocolBuffers::Client.new(servers)
      end

      @buckets = {}
    end

    def client
      @client
    end

    def client=(client)
      @client = client
    end

    def bucket(bucket)
      @buckets[bucket] = RiakOdm::Bucket.new(self, bucket) unless @buckets.has_key? bucket
      @buckets[bucket]
    end
  end
end