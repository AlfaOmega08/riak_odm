module RiakOdm
  module Document
    extend ActiveSupport::Concern

    included do
      include Components

      cattr_accessor :_bucket, :bucket_name
      class_attribute :content_type
      attr_accessor :content

      self.bucket_name = self.to_s.underscore.tableize.gsub('/', '_')
      self.content_type = 'application/json'
    end

    def initialize(attributes = {})
      @local_content_type = attributes.delete(:content_type) || self.content_type || 'application/json'
      @id = attributes.delete(:id) || ::SimpleUUID::UUID.new.to_guid

      if @local_content_type == 'application/json'
        @attributes = attributes
      else
        self.content = attributes[:content]
      end

      @new_record = true
    end

    def save
      if new_record?
        # Prevent sibling creation just because you
        options = { if_none_match: true, content_type: @local_content_type }
        self.class.bucket.store(@id, content_as_string, {}, {}, options)

        @new_record = false
      end
    end

    def destroy
      return if !persisted?
      self.class.bucket.destroy(@id)
      @destroyed = true
    end

    private
    def content_as_string
      if @local_content_type == 'application/json'
        @attributes.to_json
      else
        self.content
      end
    end

    module ClassMethods
      # Returns the bucket object for this Document.
      def bucket
        self._bucket ||= RiakOdm.cluster.bucket(self.bucket_name)
        self._bucket
      end
    end
  end
end