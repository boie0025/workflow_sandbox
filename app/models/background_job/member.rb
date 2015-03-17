# == Schema Information
#
# Table name: background_job_members
#
#  id                       :integer          not null, primary key
#  background_job_group_id :integer
#  name                     :string(255)
#  expires_at               :datetime
#  status                   :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class BackgroundJob::Member < ActiveRecord::Base
  belongs_to :background_job_group, class_name: 'BackgroundJob::Group', foreign_key: :background_job_group_id

  scope :un_run, -> { where(status: :ready) }
  scope :failed, -> { where(status: :failed) }
  scope :completed, -> { where(status: :completed) }

  enum status: [:ready, :running, :completed, :failed]

  # @return [Boolean] if there are any jobs that haven't been tried.
  # @note if a job failed, it will still count as having been run.
  def last_un_run_member_job?
    background_job_group.number_of_un_run_jobs.zero?
  end

  def finalize_last_member_job!
    background_job_group.complete!
  end

end
