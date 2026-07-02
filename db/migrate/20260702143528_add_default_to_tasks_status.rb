# frozen_string_literal: true

class AddDefaultToTasksStatus < ActiveRecord::Migration[8.1]
  def change
    change_column_default :tasks, :status, from: nil, to: 0
  end
end
