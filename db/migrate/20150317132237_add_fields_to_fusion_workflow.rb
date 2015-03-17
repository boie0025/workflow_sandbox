class AddFieldsToFusionWorkflow < ActiveRecord::Migration
  def change
    add_column :fusion_workflows, :brand_id, :integer
    add_column :fusion_workflows, :medium_id, :integer
  end
end
