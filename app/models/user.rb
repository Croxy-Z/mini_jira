# frozen_string_literal: true

class User < ApplicationRecord
  DEMO_EMAIL = "demo@example.com"

  def demo_account?
    email == DEMO_EMAIL
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { user: 0, admin: 2 }

  has_many :projects, dependent: :destroy
  has_many :task_activities, dependent: :destroy

  attr_accessor :skip_welcome_email

  after_create :send_welcome_email, unless: :skip_welcome_email?

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end

  def skip_welcome_email?
    skip_welcome_email == true
  end
end
