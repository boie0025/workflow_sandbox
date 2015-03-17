class CreateBackgroundJobMembers < ActiveRecord::Migration
  def change
    create_table :background_job_members do |t|
      t.references :background_job_group, index: true
      t.string :name
      t.datetime :expires_at
      t.integer :status

      t.timestamps
    end
  end
end
