class AddArgumentsToBackgroundJobGroups < ActiveRecord::Migration
  def change
    add_column :background_job_groups, :arguments, :text
  end
end
