# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard" do
  describe "GET /dashboard" do
    context "when user is authenticated" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }

      before { sign_in user }

      it "returns a successful response" do
        get root_path

        expect(response).to have_http_status(:ok)
      end

      it "shows only current user's dashboard data" do
        create(:project, user:, title: "Own project")
        create(:project, user: other_user, title: "Other project")

        get root_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Own project")
          expect(response.body).not_to include("Other project")
        end
      end
    end

    context "when user is unauthenticated" do
      it "redirects to the sign in page without an authentication alert" do
        get root_path

        aggregate_failures do
          expect(response).to redirect_to(new_user_session_path)
          expect(flash[:alert]).to be_blank
        end
      end
    end
  end
end
