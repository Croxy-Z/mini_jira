# frozen_string_literal: true

class CreateTaskActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :task_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.string :action, null: false
      t.string :from_status, null: false
      t.string :to_status, null: false

      t.timestamps
    end

    add_index :task_activities, %i[project_id created_at]
    add_index :task_activities, %i[task_id created_at]
  end
end
