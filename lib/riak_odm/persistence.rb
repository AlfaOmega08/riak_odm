module RiakOdm
  module Persistence
    # Returns true when the object was created with #new.
    # It is used by form_for and other helpers.
    def new_record?
      @new_record ||= false
    end

    # Returns true if the object has been destroyed and should not be used.
    def destroyed?
      @destroyed ||= false
    end

    # Returns true if there is a copy of this object in the Cluster.
    # It is true when it is both not a +new_record+ and not +destroyed+.
    def persisted?
      not (new_record? || destroyed?)
    end
  end
end