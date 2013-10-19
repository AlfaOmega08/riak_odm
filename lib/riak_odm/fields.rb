module RiakOdm
  module Fields
    extend ActiveSupport::Concern

    included do
      cattr_accessor :fields

      self.fields = {}.with_indifferent_access
    end

    module ClassMethods
      def field(name, options = {})
        fields[name] = Field.new(name.to_s, options)
        create_accessors(name.to_s, options)
      end

      def create_accessors(name, options = {})
        class_eval <<-END, __FILE__, __LINE__
          def #{name}
            read_attribute(#{name.inspect})
          end

          def #{name}=(value)
            write_attribute(#{name.inspect}, value)
          end

          def #{name}?
            read_attribute(#{name.inspect}) == true
          end
        END
      end
    end
  end
end