# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project

  enum :status, { to_do: 0, in_progress: 1, done: 2 }, default: :to_do

  validates :title, presence: true
end
