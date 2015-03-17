# == Schema Information
#
# Table name: background_job_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  expires_at :datetime
#  status     :integer
#  created_at :datetime
#  updated_at :datetime
#  arguments  :text
#

class BackgroundJob::Group < ActiveRecord::Base
  has_many :background_job_members, class_name: 'BackgroundJob::Member', foreign_key: :background_job_group_id, dependent: :destroy

  enum status: [:ready, :running, :completed, :failed, :completed_with_failures]

  serialize :arguments, Hash

  def total_number_of_jobs
    background_job_members.count
  end

  def number_of_un_run_jobs
    background_job_members.un_run.count
  end

  def number_of_completed_jobs
    background_job_members.completed.count
  end

  def number_of_failed_jobs
    background_job_members.failed.count
  end

  # This will blindly mark status as completed, or completed_with_errors.  Doesn't
  #  check to see if the jobs are actually completed.
  def complete!
    if number_of_failed_jobs.zero?
      self.completed!
    else
      self.completed_with_failures!
    end
  end
end
