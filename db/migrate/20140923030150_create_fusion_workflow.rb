class CreateFusionWorkflow < ActiveRecord::Migration
  def change
    create_table :fusion_workflows do |t|
      t.string :workflow_state
      t.string :type

      t.timestamps
    end
  end
end
