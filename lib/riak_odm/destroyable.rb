module RiakOdm
  module Destroyable
    extend ActiveSupport::Concern

    def destroy(options = {})
      return false unless persisted?
      run_callbacks(:destroy) { delete(options) }
      true
    end

    def delete(options = {})
      return false unless persisted?
      self.class.bucket.destroy(@id)
      @destroyed = true
      true
    end

    module ClassMethods
      def destroy(key, options = {})
        self.find(key).destroy(options)
      end

      # Deletes every object in the bucket, calling all the callbacks.
      # This method is potentially very slow.
      def destroy_all(options = {})
        keys = self.bucket.all_keys
        keys.each do |key|
          doc = self.class.find(key)
          doc.destroy
        end
      end

      def delete(key, options = {})
        self.bucket.destroy(key)
      end

      # Deletes every object in the Bucket, but without instantiating all the Objects and calling the Callbacks.
      # This still might be very slow.
      def delete_all(options = {})
        keys = self.bucket.all_keys
        keys.each do |key|
          self.class.delete(key, options)
        end
      end
    end
  end
end