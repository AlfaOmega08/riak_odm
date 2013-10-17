module RiakOdm
  class Index
    attr_accessor :name
    attr_accessor :type

    # Creates an Index object
    def initialize(_name, options = {})
      @name = name
      @type = options[:type] || :binary
    end
  end
end