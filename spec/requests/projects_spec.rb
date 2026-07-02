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
        create(:project, user:, title: "Visible Project")
      end

      let!(:other_project) do
        create(:project, user: other_user, title: "Hidden Project")
      end

      before do
        sign_in user
      end

      it "returns a successful response and renders only visible projects" do
        get projects_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(own_project.title)
          expect(response.body).not_to include(other_project.title)
        end
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

      it "returns a successful response and renders the project details" do
        get project_path(project)

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(project.title)
        end
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

      it "returns a successful response and renders the project edit page" do
        get edit_project_path(project)

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(project.title)
        end
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
      it "does not create a project and redirects to the sign in page" do
        expect do
          post projects_path, params: { project: attributes_for(:project) }
        end.not_to change(Project, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }

      before do
        sign_in user
      end

      it "creates a project assigned to the current user and redirects to it when params are valid" do
        expect do
          post projects_path,
               params: { project: attributes_for(:project) }
        end.to change(Project, :count).by(1)

        created_project = Project.last!

        aggregate_failures do
          expect(created_project.user).to eq(user)
          expect(response).to redirect_to(project_path(created_project))
        end
      end

      it "ignores submitted user_id and assigns the project to the current user" do
        expect do
          post projects_path,
               params: {
                 project: {
                   title: "Secure Project",
                   description: "Should belong to current user",
                   user_id: other_user.id
                 }
               }
        end.to change(Project, :count).by(1)

        expect(Project.last!.user).to eq(user)
      end

      it "does not create a project and returns an unprocessable content response when params are invalid" do
        expect do
          post projects_path,
               params: { project: attributes_for(:project, title: "") }
        end.not_to change(Project, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /projects/:id" do
    context "when user is not authenticated" do
      let(:project) { create(:project, title: "Old title") }

      it "does not update the project and redirects to the sign in page" do
        patch project_path(project), params: { project: attributes_for(:project, title: "Updated title") }

        aggregate_failures do
          expect(project.reload.title).to eq("Old title")
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:, title: "Old title") }

      before do
        sign_in user
      end

      it "updates the project and redirects to it when params are valid" do
        patch project_path(project),
              params: { project: attributes_for(:project, title: "Updated title") }

        aggregate_failures do
          expect(project.reload.title).to eq("Updated title")
          expect(response).to redirect_to(project_path(project))
        end
      end

      it "does not update the project and returns an unprocessable content response when params are invalid" do
        patch project_path(project),
              params: { project: attributes_for(:project, title: "") }

        aggregate_failures do
          expect(project.reload.title).to eq("Old title")
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user, title: "Old title") }

      before do
        sign_in user
      end

      it "does not update the project and returns a not found response" do
        patch project_path(other_project), params: { project: attributes_for(:project, title: "Updated title") }

        aggregate_failures do
          expect(other_project.reload.title).to eq("Old title")
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "DELETE /projects/:id" do
    context "when user is not authenticated" do
      let!(:project) { create(:project) }

      it "does not destroy the project and redirects to the sign in page" do
        expect do
          delete project_path(project)
        end.not_to change(Project, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let!(:project) { create(:project, user:) }
      let!(:task) { create(:task, project:) }

      before do
        sign_in user
      end

      it "destroys the project and redirects to the projects page" do
        expect do
          delete project_path(project)
        end.to change(Project, :count).by(-1)

        expect(response).to redirect_to(projects_path)
      end

      it "destroys associated tasks" do
        expect do
          delete project_path(project)
        end.to change(Task, :count).by(-1)

        expect(Task.exists?(task.id)).to be(false)
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:other_project) { create(:project, user: other_user) }

      before do
        sign_in user
      end

      it "does not destroy the project and returns a not found response" do
        expect do
          delete project_path(other_project)
        end.not_to change(Project, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
