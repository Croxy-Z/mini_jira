# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks" do
  describe "GET /projects/:project_id/tasks/:id" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }
      let(:task) { create(:task, project:) }

      it "redirects to the sign in page" do
        get project_task_path(project, task)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let(:task) { create(:task, project:) }

      before do
        sign_in user
      end

      it "returns a successful response and renders the task details" do
        get project_task_path(project, task)

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(task.title)
        end
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user) }
      let(:task) { create(:task, project: other_project) }

      before do
        sign_in user
      end

      it "returns a not found response" do
        get project_task_path(other_project, task)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /projects/:project_id/tasks/new" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }

      it "redirects to the sign in page" do
        get new_project_task_path(project)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }

      before do
        sign_in user
      end

      it "returns a successful response and renders the new task form" do
        get new_project_task_path(project)

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(project.title)
        end
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:project) { create(:project, user: other_user) }

      before do
        sign_in user
      end

      it "returns a not found response" do
        get new_project_task_path(project)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /projects/:project_id/tasks/:id/edit" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }
      let(:task) { create(:task, project:) }

      it "redirects to the sign in page" do
        get edit_project_task_path(project, task)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let(:task) { create(:task, project:) }

      before do
        sign_in user
      end

      it "returns a successful response and renders the task edit page" do
        get edit_project_task_path(project, task)

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(task.title)
        end
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user) }
      let(:task) { create(:task, project: other_project) }

      before do
        sign_in user
      end

      it "returns a not found response" do
        get edit_project_task_path(other_project, task)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /projects/:project_id/tasks" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }

      it "does not create a task and redirects to the sign in page" do
        expect do
          post project_tasks_path(project), params: { task: attributes_for(:task) }
        end.not_to change(Task, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }

      before do
        sign_in user
      end

      it "creates a task in the project and redirects to the project page when params are valid" do
        expect do
          post project_tasks_path(project), params: { task: attributes_for(:task, title: "New task") }
        end.to change(Task, :count).by(1)

        created_task = Task.last!

        aggregate_failures do
          expect(created_task.project).to eq(project)
          expect(created_task.title).to eq("New task")
          expect(response).to redirect_to(project_path(project))
        end
      end

      it "creates a new task with the default status even when status param is provided" do
        post project_tasks_path(project), params: { task: attributes_for(:task, status: "done") }

        aggregate_failures do
          expect(Task.last!).to be_to_do
          expect(response).to redirect_to(project_path(project))
        end
      end

      it "does not create a task and returns an unprocessable content response when params are invalid" do
        expect do
          post project_tasks_path(project), params: { task: attributes_for(:task, title: "") }
        end.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user) }

      before do
        sign_in user
      end

      it "does not create a task and returns a not found response" do
        expect do
          post project_tasks_path(other_project), params: { task: attributes_for(:task, title: "New task") }
        end.not_to change(Task, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /projects/:project_id/tasks/:id" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }
      let(:task) { create(:task, project:, title: "Old title") }

      it "does not update the task and redirects to the sign in page" do
        patch project_task_path(project, task), params: { task: attributes_for(:task, title: "Updated title") }

        aggregate_failures do
          expect(task.reload.title).to eq("Old title")
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let(:task) { create(:task, project:, title: "Old title") }

      before do
        sign_in user
      end

      it "updates the task and redirects to the project page when params are valid" do
        patch project_task_path(project, task), params: { task: attributes_for(:task, title: "Updated title") }

        aggregate_failures do
          expect(task.reload.title).to eq("Updated title")
          expect(response).to redirect_to(project_path(project))
        end
      end

      it "does not update the task and returns an unprocessable content response when params are invalid" do
        patch project_task_path(project, task), params: { task: attributes_for(:task, title: "") }

        aggregate_failures do
          expect(task.reload.title).to eq("Old title")
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user) }
      let(:task) { create(:task, project: other_project, title: "Old title") }

      before do
        sign_in user
      end

      it "does not update the task and returns a not found response" do
        patch project_task_path(other_project, task), params: { task: attributes_for(:task, title: "Updated title") }

        aggregate_failures do
          expect(task.reload.title).to eq("Old title")
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "PATCH /projects/:project_id/tasks/:id/move" do
    context "when user is not authenticated" do
      let(:project) { create(:project) }
      let(:task) { create(:task, project:, status: :to_do) }

      it "does not move the task" do
        patch move_project_task_path(project, task),
              params: { task: { status: "done" } },
              as: :json

        aggregate_failures do
          expect(task.reload).to be_to_do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context "when user owns the project" do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let(:task) { create(:task, project:, status: :to_do) }

      before do
        sign_in user
      end

      it "moves the task when status is valid" do
        patch move_project_task_path(project, task),
              params: { task: { status: "done" } },
              as: :json

        aggregate_failures do
          expect(task.reload).to be_done
          expect(response).to have_http_status(:ok)
        end
      end

      it "does not move the task when status is invalid" do
        patch move_project_task_path(project, task),
              params: { task: { status: "archived" } },
              as: :json

        aggregate_failures do
          expect(task.reload).to be_to_do
          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:other_project) { create(:project, user: other_user) }
      let(:task) { create(:task, project: other_project, status: :to_do) }

      before do
        sign_in user
      end

      it "does not move the task" do
        patch move_project_task_path(other_project, task),
              params: { task: { status: "done" } },
              as: :json

        aggregate_failures do
          expect(task.reload).to be_to_do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "DELETE /projects/:project_id/tasks/:id" do
    context "when user is not authenticated" do
      let!(:project) { create(:project) }
      let!(:task) { create(:task, project:) }

      it "does not destroy the task and redirects to the sign in page" do
        expect do
          delete project_task_path(project, task)
        end.not_to change(Task, :count)

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

      it "destroys the task and redirects to the project page" do
        expect do
          delete project_task_path(project, task)
        end.to change(Task, :count).by(-1)

        expect(response).to redirect_to(project_path(project))
      end
    end

    context "when user does not own the project" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let!(:other_project) { create(:project, user: other_user) }
      let!(:task) { create(:task, project: other_project) }

      before do
        sign_in user
      end

      it "does not destroy the task and returns a not found response" do
        expect do
          delete project_task_path(other_project, task)
        end.not_to change(Task, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
