module RiakOdm
  module Indexes
    extend ActiveSupport::Concern

    included do
      cattr_accessor :indexes
      @@indexes = {}
    end

    module ClassMethods
      def index(name, options = {})
        self.indexes[name] = RiakOdm::Index.new(name, options)
      end
    end
  end
end