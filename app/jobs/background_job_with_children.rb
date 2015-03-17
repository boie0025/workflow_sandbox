# Include this module, and write a processor for a piece of a batch.
# @example
# class DummyBackgroundJobWithChildren < ActiveJob::Base
#   include BackgroundJobWithChildren
#
#   @note this method will be run once for each id_array item
#   def perform_child
#     list_item = List.find(model_id)
#     list_item.mark_as_complete
#   end
#
#   def self.define_children(list_batch_id)
#     id_array = ListBatch.find(list_batch_id).lists.map(&:id)
#     # @note at present, you must call self.create_child_jobs(id_array) to
#     #  kick off building the jobs.
#     self.create_child_jobs(id_array)
#   end
#
#   rescue_from(ArgumentError) do |e|
#     # Do something with the error
#   end
#
#   def group_complete
#     # do something when all are updated.
#   end
#
# end
#
# @example usage of example class
#
# list_batch_id = 213 #
# DummyBackgroundJobWithChildren.define_children(list_batch_id)
#
#


module BackgroundJobWithChildren
  extend ActiveSupport::Concern

  included do
    attr_accessor :background_job_member_id, :model_id
    around_perform do |job, block|
      background_job_member = self.class.background_job_member_from_job(job)
      begin
        background_job_member.running!
        block.call(*job.arguments)
        background_job_member.completed!
      rescue => e
        background_job_member.failed!
        raise e
      ensure
        check_if_last_member_job(job)
      end

    end
  end

  def background_job_member
    @background_job_member ||= BackgroundJob::Member.find(background_job_member_id)
  end

  delegate :background_job_group, to: :background_job_member

  def perform(*args)
    opts = args.extract_options!
    raise ArgumentError unless self.model_id = opts[:model_id]
    raise ArgumentError unless self.background_job_member_id = opts[:background_job_member_id]
    perform_child
  end

  def perform_child
    raise NotImplementedError, "Define perform_child to work with id in #model_id."
  end

  def check_if_last_member_job(job)
    background_job_member = self.class.background_job_member_from_job(job)
    if background_job_member.last_un_run_member_job?
      job.group_complete # Run callback declared on including job
      background_job_member.finalize_last_member_job!
    end
  end

  def group_complete
    # implement to use
  end

  module ClassMethods

    def background_job_member_from_job(job)
      BackgroundJob::Member.find(job.arguments.first[:background_job_member_id])
    end

    # @override for more specific/custom name.
    def background_job_name
      self.name.to_s
    end

    # @param [Array <Integer>] id_array an array of items to be sent to perform
    # @param [Hash] a hash of additional information to be stored on the group
    #  and also available to the job through job#arguments
    def create_child_jobs(id_array, **opts)
      background_job_group = BackgroundJob::Group.create(
        name: background_job_name,
        status: :running,
        arguments: opts)

      # Create all the background job members first.
      background_job_members = id_array.map do |model_id|
        [ BackgroundJob::Member.create(
            { name: background_job_name,
              status: :ready,
              expires_at: 2.months.from_now,
              background_job_group: background_job_group }),
          model_id ]
      end

      # Iterate through background job members, and kick them off.
      background_job_members.each do |background_job_member, model_id|
        perform_later(opts.merge({ model_id: model_id,
          background_job_member_id: background_job_member.id}))
      end
    end

  end
end
