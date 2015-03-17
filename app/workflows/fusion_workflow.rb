class FusionWorkflow < ActiveRecord::Base
  include Workflow
  attr_accessor :brand, :medium

end
