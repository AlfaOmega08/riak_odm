module RiakOdm
  class Index
    attr_accessor :name
    attr_accessor :type

    def initialize(_name, options = {})
      @name = _name
      @type = options[:type] || :binary
    end
  end
end