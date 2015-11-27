class InsertListener

  include CelluloidIOPGListener.client(:unlisten_wrapper_with_termination)

  def insert_callback(channel, payload)
    # <-- within the unlisten_wrapper's block if :insert_callback is the callback_method
    debug "#{self.class} channel is #{channel}"
    debug "#{self.class} payload is #{payload}"
  end

end
