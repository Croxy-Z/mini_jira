# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks" do
  describe "task board rendering" do
    let(:user) { create(:user) }
    let(:project) { create(:project, user:) }
    let!(:task) { create(:task, project:, title: "Drag me", status: :to_do) }

    before do
      login_as user, scope: :user
    end

    it "renders the task in the initial column" do
      visit project_path(project)

      aggregate_failures do
        expect(page).to have_css("#tasks_to_do #task_#{task.id}", text: "Drag me")
        expect(page).to have_css("#tasks_in_progress")
        expect(page).to have_css("#tasks_done")
      end
    end

    # SortableJS drag-and-drop is not reliably testable in headless Chrome;
    # backend move logic is covered in request specs.
    it "renders a task in the correct column after its status changes" do
      visit project_path(project)

      expect(page).to have_css("#tasks_to_do #task_#{task.id}", text: "Drag me")

      task.update!(status: :done)

      visit current_path

      aggregate_failures do
        expect(page).to have_css("#tasks_done #task_#{task.id}", text: "Drag me")
        expect(page).to have_no_css("#tasks_to_do #task_#{task.id}")
      end
    end

    it "creates a task from the turbo modal" do
      visit project_path(project)

      click_link "Add Task"

      aggregate_failures do
        expect(page).to have_css("turbo-frame#modal", text: "New task")
        expect(page).to have_field("Title")
        expect(page).to have_field("Description")
      end

      within "turbo-frame#modal" do
        fill_in "Title", with: "New turbo task"
        fill_in "Description", with: "Created from the task modal"
        click_button "Create Task"
      end

      aggregate_failures do
        expect(page).to have_css("#tasks_to_do", text: "New turbo task")
        expect(page).to have_css("#tasks_to_do", text: "Created from the task modal")
        expect(page).to have_no_css("turbo-frame#modal", text: "New task")
        expect(page).to have_css("#flash", text: "Task was successfully created.")
      end
    end

    it "updates a task from the task details modal" do
      visit project_path(project)

      within "#task_#{task.id}" do
        click_link "Open"
      end

      aggregate_failures do
        expect(page).to have_css("turbo-frame#modal", text: "Task details")
        expect(page).to have_css("turbo-frame#modal", text: task.title)
        expect(page).to have_css("turbo-frame#modal", text: task.description)
        expect(page).to have_css("turbo-frame#modal", text: task.status.humanize)
      end

      within "turbo-frame#modal" do
        click_link "Edit task"
      end

      aggregate_failures do
        expect(page).to have_css("turbo-frame#modal", text: "Edit task")
        expect(page).to have_field("Title", with: "Drag me")
      end

      within "turbo-frame#modal" do
        fill_in "Title", with: "Updated task title"
        fill_in "Description", with: "Updated task description"
        click_button "Update Task"
      end

      aggregate_failures do
        expect(page).to have_css("#tasks_to_do #task_#{task.id}", text: "Updated task title")
        expect(page).to have_css("#tasks_to_do #task_#{task.id}", text: "Updated task description")
        expect(page).to have_css("#flash", text: "Task was successfully updated.")
        expect(page).to have_no_css("turbo-frame#modal", text: "Edit task")
      end
    end

    it "deletes a task from the task details modal" do
      visit project_path(project)

      within "#task_#{task.id}" do
        click_link "Open"
      end

      expect(page).to have_css("turbo-frame#modal", text: "Task details")

      within "turbo-frame#modal" do
        accept_confirm "Are you sure you want to delete this task?" do
          click_button "Delete task"
        end
      end

      aggregate_failures do
        expect(page).to have_no_css("#task_#{task.id}")
        expect(page).to have_no_css("turbo-frame#modal", text: "Task details")
        expect(page).to have_css("#tasks_to_do_count", text: "0")
        expect(page).to have_css("#flash", text: "Task was successfully deleted.")
        expect(page).to have_css("#tasks_to_do_empty_state", text: "No tasks yet")
      end
    end
  end
end
