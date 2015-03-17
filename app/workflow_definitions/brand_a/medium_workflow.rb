module BrandA
  class MediumWorkflow < ::FusionWorkflow

    workflow do
      state :new do
        event :begin, transitions_to: :step_one
      end
      state :step_one do
        event :complete, transitions_to: :step_two
      end
      state :step_two do
        event :complete, transitions_to: :step_three
      end
      state :step_three do
        event :complete, transitions_to: :step_four
      end
      state :step_four do
        event :complete, transitions_to: :step_five
      end
      state :step_five do
        event :accept, transitions_to: :final_step
        event :reject, transitions_to: :step_four
      end
      state :final_step do
        event :complete, transitions_to: :accepted
      end
      state :accepted
      state :rejected
    end

    def on_step_one_entry(*args)
      puts "initialize new workflow"
      WorkflowActivityJob.perform_later(workflow_id: self.id)
    end

    def on_step_two_entry(new_state, *args)
      puts "begin step two"
      SeveralChildrenJob.define_children(workflow_id: self.id)
    end

    def on_step_three_entry(new_state, *args)
      puts "begin step three"
      WorkflowActivityJob.perform_later(workflow_id: self.id)
    end

    def on_step_four_entry(new_state, *args)
      puts "begin step four"
      WorkflowActivityJob.perform_later(workflow_id: self.id)
    end

    def on_step_five_entry(new_state, *args)
      puts "You must complete or reject this step."
    end

  end
end
