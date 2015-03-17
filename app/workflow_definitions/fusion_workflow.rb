class FusionWorkflow < ActiveRecord::Base
  include Workflow

  delegate :events, to: :current_state
  delegate :keys, to: :events, prefix: :event

  # this will move to the next step in the current workflow
  def continue!
    if event_keys.many?
      raise Workflow::WorkflowError, 'the current state has multiple possible transitions'
    elsif event_keys.none?
      raise Workflow::WorkflowError, 'there are no more states left to transition to'
    else
      next_event = event_keys.first
      self.public_send("#{next_event}!")
    end
  end

end
