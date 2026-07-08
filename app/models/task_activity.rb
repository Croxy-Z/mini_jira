# frozen_string_literal: true

class TaskActivity < ApplicationRecord
  ACTION_MOVED = "moved"

  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates :action, presence: true, inclusion: { in: [ACTION_MOVED] }
  validates :from_status, presence: true, inclusion: { in: Task.statuses.keys }
  validates :to_status, presence: true, inclusion: { in: Task.statuses.keys }
end
