class CreateBackgroundJobGroups < ActiveRecord::Migration
  def change
    create_table :background_job_groups do |t|
      t.string :name
      t.datetime :expires_at
      t.integer :status

      t.timestamps
    end
  end
end
