# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :protect_demo_account!, only: %i[update destroy]

    private

    def protect_demo_account!
      return unless current_user&.demo_account?

      redirect_to authenticated_root_path,
                  alert: "Demo account settings are protected."
    end
  end
end
