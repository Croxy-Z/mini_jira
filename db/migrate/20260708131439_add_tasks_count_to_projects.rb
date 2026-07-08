# frozen_string_literal: true

class AddTasksCountToProjects < ActiveRecord::Migration[8.1]
  def up
    add_column :projects, :tasks_count, :integer, null: false, default: 0

    execute <<~SQL.squish
      UPDATE projects
      SET tasks_count = (
        SELECT COUNT(*)
        FROM tasks
        WHERE tasks.project_id = projects.id
      )
    SQL
  end

  def down
    remove_column :projects, :tasks_count
  end
end
