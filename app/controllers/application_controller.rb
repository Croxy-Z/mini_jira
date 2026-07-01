# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  after_action :verify_pundit_authorization, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:alert] = t("pundit.unauthorized")
        redirect_to(request.referer || root_path)
      end

      format.json do
        render json: { error: "forbidden", messages: [t("pundit.unauthorized")] },
               status: :forbidden
      end
    end
  end

  def verify_pundit_authorization
    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end
end
