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

    # Finds using an index instead of the key.
    # The index might be a Secondary Index or other TODOs.
    #
    # @param index [Hash] an hash of only one element.
    # @option index [String] key this will be used as the index name. You must omit the +_int+ or +_bin+ suffix that
    #   will be added by RiakOdm.
    # @option index [Array/Binary] value if an array it specifies a range. If a single value it specifies the exact
    #   value to be find.
    # @option options [Hash] see RiakOdm::Criteria#new
    def find_by(index, options = {})
      idx, value_or_range = index.first

      raise unless self.indexes[idx]

      RiakOdm::Criteria.new(self, self.indexes[idx].full_name, value_or_range, options)
    end
  end
end