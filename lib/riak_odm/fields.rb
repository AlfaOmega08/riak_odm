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
        define_method("#{name}") { read_attribute(name) }
        define_method("#{name}=") { |value| write_attribute(name, value) }
        define_method("#{name}?") { read_attribute(name) == true }
      end
    end
  end
end