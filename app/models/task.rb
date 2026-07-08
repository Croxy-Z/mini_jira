# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project

  has_many :task_activities, dependent: :destroy

  enum :status, { to_do: 0, in_progress: 1, done: 2 }, default: :to_do

  validates :title, presence: true, length: { maximum: 160 }
  validates :description, length: { maximum: 2000 }
end
