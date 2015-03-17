class WorkflowActivityJob
  attr_accessor :workflow_id

  def initialize(workflow_id: )
    self.workflow_id = workflow_id
  end

  def perform
    puts "Starting #{workflow.current_state} job"
    sleep 3
    puts "Completing #{workflow.current_state} job"
    workflow.complete!
  end

  def workflow
    FusionWorkflow.find(workflow_id)
  end

end
