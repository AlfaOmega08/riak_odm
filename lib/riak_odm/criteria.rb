module RiakOdm
  class Criteria
    # Creates a new critera on a give +document+ object.
    # @param options [Hash] options will be passed to +#find+ when it gets called.
    def initialize(document, index, value_or_range, options = {})
      @document = document
      @index = index
      @value_or_range = value_or_range
      @continuation = nil
      @max_results = nil
      @options = options
    end

    # Returns all Documents matching the criteria
    def all(options = nil)
      @keys ||= execute.keys
      @document.find(@keys, options || @options)
    end

    # Returns the first Document matching the criteria
    def first(options = nil)
      old_max = @max_results
      @max_results = 1
      key = execute[0]
      @max_results = old_max
      @document.find(key, options || @options)
    end

    # Puts a limit on the number of results to be fetched.
    # This results in the :max_results parameter to be set.
    def limit(count)
      @max_results = count
    end

    # Iterates through all Documents matched by this criteria.
    def each(&block)
      @keys ||= execute.keys
      @keys.each do |key|
        obj = @document.find(key, @options)
        yield obj
      end
    end

    # Returns a specific document matched by this criteria.
    def [](index)
      @keys ||= execute.keys
      @document.find(@keys[index])
    end

    # Returns an array of keys matching this criteria.
    def execute
      @document.bucket.find_by(@index, @value_or_range, @options.merge({ continuation: @continuation, max_results: @max_results }))
    end
  end
end