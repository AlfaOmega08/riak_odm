module RiakOdm
  class Cluster
    # Initializes a new cluster object
    #
    # @param servers [Array] an array of { :host, :port } hashes defining servers in the cluster. One of these will be
    #   randomly selected for connection.
    # @param use_http [Boolean] if you wish for some masochist motivation to use the HTTP interacace instead of protocol
    #   buffers, set this to true.
    def initialize(servers, use_http = false)
      if use_http
        @client = RiakOdm::Client::Http::Client.new(servers)
      else
        @client = RiakOdm::Client::ProtocolBuffers::Client.new(servers)
      end

      @buckets = {}
    end

    # Returns the PB/HTTP interface
    def client
      @client
    end

    # Sets the PB/HTTP interface
    def client=(client)
      @client = client
    end

    # Returns the bucket object for the given bucket name, or creates one if not existing
    #
    # @param bucket [String] name of the bucket.
    def bucket(bucket)
      @buckets[bucket] = RiakOdm::Bucket.new(self, bucket) unless @buckets.has_key? bucket
      @buckets[bucket]
    end
  end
end