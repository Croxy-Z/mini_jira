# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: "no-reply@mini-jira.com"

  def welcome_email(user)
    @user = user

    mail(to: @user.email, subject: "Welcome to Jira Clone!")
  end
end
