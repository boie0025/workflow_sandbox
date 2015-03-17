class WorkflowActivityJob
  attr_accessor :workflow

  def initialize(workflow: )
    self.workflow = workflow
  end

  def perform
    sleep 3
    puts workflow.current_state
    workflow.continue!
  end

end
