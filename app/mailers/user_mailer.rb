# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: "no-reply@mini-jira.com"

  def welcome_email(user)
    @user = user

    mail(to: @user.email, subject: t(".subject"))
  end
end
