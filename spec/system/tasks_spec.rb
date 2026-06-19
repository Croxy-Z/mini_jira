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
  end
end
