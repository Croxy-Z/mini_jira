# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user

  has_many :tasks, dependent: :destroy
  has_many :task_activities, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
end
