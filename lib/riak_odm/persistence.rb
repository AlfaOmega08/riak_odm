module RiakOdm
  module Persistence
    def new_record?
      @new_record ||= false
    end

    def destroyed?
      @destroyed ||= false
    end

    def persisted?
      not (new_record? || destroyed?)
    end
  end
end