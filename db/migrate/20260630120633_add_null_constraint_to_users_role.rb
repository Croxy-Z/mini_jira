# frozen_string_literal: true

class AddNullConstraintToUsersRole < ActiveRecord::Migration[8.1]
  def up
    change_column_null :users, :role, false, 0
  end

  def down
    change_column_null :users, :role, true
  end
end
