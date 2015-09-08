class FusionWorkflow < ActiveRecord::Base
  include Workflow

  def current_state
    mod_state = super
    # class << mod_state
    #   def on_entry
    #     -> { binding.pry }
    #   end
    # end
    mod_state
  end

  # To define accessors in sublcasses, use store_accessor :store, [symbols]
  store :meta, accessors: [ :skipped_states ], coder: YAML

  def workflow_name
    self.class.to_s.tableize.singularize.humanize.titleize
  end

  def run_on_entry(*args)
    binding.pry
    super
  end

  # blar  # a.skipped_states.include?(:a)

end
