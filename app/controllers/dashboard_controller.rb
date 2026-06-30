# frozen_string_literal: true

class DashboardController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :index
  def index; end
end
