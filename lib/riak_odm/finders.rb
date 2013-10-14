module RiakOdm
  module Finders
    # Finds one or more documents in the Bucket.
    #
    # @param id [String|Hash] the id(s) to search in the bucket
    # @param options [Hash] any possible fetch parameter for Riak (see <tt>ProtocolBuffers::Client#fetch</tt>).
    def find(id, options = {})
      if id.is_a? Array
        id.map { |id| find(id, options) }
      else
        self.bucket.find(id, options)
      end
    end
  end
end