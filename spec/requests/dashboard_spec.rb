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

      it "shows only current user's dashboard data" do
        user = create(:user)
        other_user = create(:user)

        own_project = create(:project, user: user, title: "Own project")
        create(:task, project: own_project, status: :done)

        other_project = create(:project, user: other_user, title: "Other project")
        create(:task, project: other_project, status: :done)

        sign_in user

        get root_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Own project")
          expect(response.body).not_to include("Other project")
          expect(response.body).to include("1")
        end
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
