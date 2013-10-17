module RiakOdm
  module Indexes
    extend ActiveSupport::Concern

    included do
      cattr_accessor :indexes
      @@indexes = {}
    end

    module ClassMethods
      # Create a new index definition for this Document Class.
      # @param name [String] name of the index.
      # @param options [Hash] various options.
      # @option options [Symbol] :type can be :binary or :integer. If omitted, :binary is used.
      def index(name, options = {})
        self.indexes[name] = RiakOdm::Index.new(name, options)
      end
    end
  end
end