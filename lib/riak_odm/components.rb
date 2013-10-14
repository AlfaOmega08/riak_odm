module RiakOdm
  module Components
    extend ActiveSupport::Concern

    included do
      extend Finders
    end
  end
end