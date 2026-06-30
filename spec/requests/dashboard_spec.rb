# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard" do
  describe "GET /dashboard" do
    context "when user is authenticated" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "returns a successful response" do
        get root_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is unauthenticated" do
      it "redirects to the sign in page" do
        get root_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
