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
      let(:other_user) { create(:user) }

      let!(:own_project) do
        create(:project, user:)
      end

      let!(:other_project) do
        create(:project, user: other_user)
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

  describe "GET /projects/:id" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }

      it "redirects to the sign in page" do
        get project_path(project)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }

      before do
        sign_in user
      end

      it "returns a successful response" do
        get project_path(project)

        expect(response).to have_http_status(:ok)
      end

      it "renders the project details" do
        get project_path(project)

        expect(response.body).to include(project.title)
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user) }

      before do
        sign_in user
      end

      it "returns a not found response" do
        get project_path(other_project)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /projects/new" do
    context "when user is not authenticated" do
      it "redirects to the sign in page" do
        get new_project_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it "returns a successful response" do
        get new_project_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /projects/:id/edit" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }

      it "redirects to the sign in page" do
        get edit_project_path(project)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }

      before do
        sign_in user
      end

      it "returns a successful response" do
        get edit_project_path(project)

        expect(response).to have_http_status(:ok)
      end

      it "renders the project edit page" do
        get edit_project_path(project)

        expect(response.body).to include(project.title)
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user) }

      before do
        sign_in user
      end

      it "returns a not found response" do
        get edit_project_path(other_project)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /projects" do
    context "when user is not authenticated" do
      let(:project_params) { attributes_for(:project) }

      it "does not create a project" do
        expect do
          post projects_path, params: { project: project_params }
        end.not_to change(Project, :count)
      end

      it "redirects to the sign in page" do
        post projects_path, params: { project: project_params }

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      let(:user) { create(:user) }
      let(:project_params) { attributes_for(:project) }

      before do
        sign_in user
      end

      it "creates a project" do
        expect do
          post projects_path, params: { project: project_params }
        end.to change(Project, :count).by(1)
      end

      it "assigns the created project to the current user" do
        post projects_path, params: { project: project_params }

        expect(Project.last.user).to eq(user)
      end

      it "redirects to the created project" do
        post projects_path, params: { project: project_params }

        expect(response).to redirect_to(project_path(Project.last))
      end
    end

    context "when params are invalid" do
      let(:user) { create(:user) }
      let(:project_params) { attributes_for(:project, title: "") }

      before do
        sign_in user
      end

      it "does not create a project" do
        expect do
          post projects_path, params: { project: project_params }
        end.not_to change(Project, :count)
      end

      it "returns an unprocessable entity response" do
        post projects_path, params: { project: project_params }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
