module BrandA
  class MediumWorkflow < ::FusionWorkflow

    workflow do
      state :new do
        event :first_event, transitions_to: :step_two
      end
      state :step_two do
        event :second_event, transitions_to: :step_three
      end
      state :step_three do
        event :third_event, transitions_to: :step_four
      end
      state :step_four do
        event :fourth_event, transitions_to: :step_five
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

    def first_event
      puts "step two running"

    end

    def second_event
      puts "step three running"
      WorkflowActivityJob.new(workflow: self).perform
    end

    def third_event
      puts "step four running"
    end

    def fourth_event
      puts "step five running"
    end

    def complete
      puts "final step"
    end

  end
end
