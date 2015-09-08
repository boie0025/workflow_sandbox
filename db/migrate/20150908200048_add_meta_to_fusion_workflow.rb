class AddMetaToFusionWorkflow < ActiveRecord::Migration
  def change
    add_column :fusion_workflows, :meta, :text
  end
end
