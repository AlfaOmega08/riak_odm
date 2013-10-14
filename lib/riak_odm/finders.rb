module RiakOdm
  module Finders
    def find(id, options = {})
      if id.is_a? Array
        id.map { |id| find(id, options) }
      else
        self.bucket.find(id, options)
      end
    end
  end
end