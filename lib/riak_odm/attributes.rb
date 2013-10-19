module RiakOdm
  module Attributes
    def read_attribute(name)
      @attributes[name]
    end

    def write_attribute(name, value)
      @attributes[name] = value
    end
  end
end