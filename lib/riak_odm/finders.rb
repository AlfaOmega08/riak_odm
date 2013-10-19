module RiakOdm
  module Finders
    # Finds one or more documents in the Bucket.
    #
    # @param id [String|Hash] the id(s) to search in the bucket
    # @param options [Hash] any possible fetch parameter for Riak (see <tt>ProtocolBuffers::Client#fetch</tt>).
    #
    # If +id+ is an Array, not_found documents are set as +nil+ in the returning Array.
    # If +id+ is a single String or Integer or other identifier, and the document is not found, +nil+ is returned.
    def find(id, options = {})
      if id.is_a? Array
        id.map { |id| find(id, options) }
      else
        result = self.bucket.find(id, options)
        if result
          document = self.allocate
          document.initialize_from_rpb_get_resp id, result
        else
          nil
        end
      end
    end

    # Same as <tt>#find</tt>. Raises a DocumentNotFound exception whenever a document is not found.
    # RiakOdm::Errors::DocumentNotFound are automatically handled by Rails to report a 404!
    def find!(id, options = {})
      if id.is_a? Array
        id.map { |id| find!(id, options) }
      else
        find(id, options) or raise RiakOdm::Errors::DocumentNotFound
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