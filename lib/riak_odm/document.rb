module RiakOdm
  module Document
    extend ActiveSupport::Concern

    included do
      include Components

      cattr_accessor :_bucket, :bucket_name
      class_attribute :content_type
      attr_accessor :content
      attr_accessor :id

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

    def model_name
      self.class.model_name
    end

    def save
      if new_record?
        # Prevent sibling creation just because you
        options = { if_none_match: true, content_type: @local_content_type }
        self.class.bucket.store(@id, content_as_string, {}, {}, options)

        @new_record = false
      else
        options = { if_not_modified: true, content_type: @local_content_type, vclock: @vclock }
        self.class.bucket.store(@id, content_as_string, {}, {}, options)
      end
    end

    def update_attributes(attributes = {})
      return false if @local_content_type != 'application/json'
      @attributes = attributes
      save
    end

    def destroy
      return if !persisted?
      self.class.bucket.destroy(@id)
      @destroyed = true
    end

    def initialize_from_rpb_get_resp(id, response)
      @id = id
      @vclock = response.vclock
      @local_content_type = response.content[0].content_type

      if @local_content_type == 'application/json'
        @attributes = JSON.parse(response.content[0].value)
      else
        self.content = response.content[0].value
      end
      self
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