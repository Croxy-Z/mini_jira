# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { user: 0, manager: 1, admin: 2 }

  has_many :projects, dependent: :destroy

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
