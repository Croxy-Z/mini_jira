# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects" do
  describe "GET /projects" do
    context "when user is not authenticated" do
      it "redirects to the sign in page" do
        get projects_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      let(:user) { create(:user) }

      let!(:own_project) do
        create(:project, user: user, title: "Own Project")
      end

      let!(:other_project) do
        create(:project, title: "Other Project")
      end

      before do
        sign_in user
      end

      it "returns a successful response" do
        get projects_path

        expect(response).to have_http_status(:ok)
      end

      it "renders only projects visible to the current user" do
        get projects_path

        expect(response.body).to include(own_project.title)
        expect(response.body).not_to include(other_project.title)
      end
    end
  end
end
