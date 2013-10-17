module RiakOdm
  class Criteria
    def initialize(document, index, value_or_range, options = {})
      @document = document
      @index = index
      @value_or_range = value_or_range
      @continuation = nil
      @max_results = nil
      @options = options
    end

    def all(options = nil)
      @keys ||= execute.keys
      @document.find(@keys, options || @options)
    end

    def first(options = nil)
      @max_results = 1
      key = execute[0]
      @document.find(key, options || @options)
    end

    def limit(count)
      @max_results = count
    end

    def each(&block)
      @keys ||= execute.keys
      @keys.each do |key|
        obj = @document.find(key, @options)
        yield obj
      end
    end

    def [](index)
      @keys ||= execute.keys
      @document.find(@keys[index])
    end

    def execute
      @document.bucket.find_by(@index, @value_or_range, @options.merge({ continuation: @continuation, max_results: @max_results }))
    end
  end
end