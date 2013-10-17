module RiakOdm
  module Components
    extend ActiveSupport::Concern

    included do
      include Indexes
      include Persistence
      extend Finders
    end
  end
end