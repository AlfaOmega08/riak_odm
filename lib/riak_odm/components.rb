module RiakOdm
  module Components
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming
      include ActiveModel::Conversion
      include ActiveModel::Validations
      include Attributes
      include Fields
      include Indexes
      include Destroyable
      include Persistence
      extend ActiveModel::Callbacks
      extend Finders

      define_model_callbacks :save, :validation, :destroy
    end
  end
end