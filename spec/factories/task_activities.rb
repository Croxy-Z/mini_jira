# frozen_string_literal: true

FactoryBot.define do
  factory :task_activity do
    task
    project { task.project }
    user { project.user }
    action { TaskActivity::ACTION_MOVED }
    from_status { "to_do" }
    to_status { "done" }
  end
end
