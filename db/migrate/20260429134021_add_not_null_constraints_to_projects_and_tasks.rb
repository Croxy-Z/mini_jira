class AddNotNullConstraintsToProjectsAndTasks < ActiveRecord::Migration[8.1]
  def change
    change_column_null :projects, :title, false
    change_column_null :tasks, :title, false
    change_column_null :tasks, :status, false
  end
end
