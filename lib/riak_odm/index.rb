module RiakOdm
  class Index
    attr_accessor :name
    attr_accessor :type

    # Creates an Index object
    def initialize(_name, options = {})
      @name = _name
      @type = options[:type] || :binary
    end

    def full_name
      if @type == :binary
        @name + '_bin'
      else
        @name + '_int'
      end
    end
  end
end