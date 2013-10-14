module RiakOdm
  module Document
    extend ActiveSupport::Concern

    included do
      include Components

      cattr_accessor :_bucket, :bucket_name
      self.bucket_name = self.to_s.underscore.tableize.gsub('/', '_')
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