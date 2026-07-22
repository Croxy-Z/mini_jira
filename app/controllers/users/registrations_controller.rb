# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :protect_demo_account!, only: %i[update destroy]
    # rubocop:enable Rails/LexicallyScopedActionFilter

    private

    def protect_demo_account!
      return unless current_user&.demo_account?

      redirect_to authenticated_root_path,
                  alert: t("users.registrations.demo_account_protected")
    end
  end
end
