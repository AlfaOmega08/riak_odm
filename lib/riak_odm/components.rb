module RiakOdm
  module Components
    extend ActiveSupport::Concern

    included do
      include Indexes
      include Destroyable
      include Persistence
      extend ActiveModel::Callbacks
      extend Finders

      define_model_callbacks :destroy
    end
  end
end