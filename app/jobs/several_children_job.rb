class SeveralChildrenJob < ActiveJob::Base
  include BackgroundJobWithChildren

  # in this job, the model id is just a pause time
  def perform_child
    puts "Sleeping for #{sleep_duration} seconds"
    sleep sleep_duration
  end

  def self.define_children(workflow_id: )
    durations = [1, 1, 5, 15, 1, 3, 7, 7]
    self.create_child_jobs(durations, workflow_id: workflow_id)
  end

  def sleep_duration
    model_id
  end

  def group_complete
    workflow_id = arguments.first[:workflow_id]
    workflow = FusionWorkflow.find(workflow_id)
    workflow.complete!
  end

end
