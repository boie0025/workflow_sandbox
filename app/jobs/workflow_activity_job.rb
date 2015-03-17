class WorkflowActivityJob < ActiveJob::Base
  attr_accessor :workflow_id

  def perform(*args)
    opts = args.extract_options!
    self.workflow_id = opts[:workflow_id]
    puts "Starting #{workflow.current_state} job"
    sleep 3
    puts "Completing #{workflow.current_state} job"
    workflow.complete!
  end

  def workflow
    FusionWorkflow.find(workflow_id)
  end

end
