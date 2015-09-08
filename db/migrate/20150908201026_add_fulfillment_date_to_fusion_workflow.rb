class AddFulfillmentDateToFusionWorkflow < ActiveRecord::Migration
  def change
    add_column :fusion_workflows, :fulfillment_date, :date
  end
end
