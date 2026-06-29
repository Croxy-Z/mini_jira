# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects" do
  describe "task creation from project board" do
    let(:user) { create(:user) }
    let(:project) { create(:project, user:) }

    before do
      sign_in user
    end

    it "creates a task from the turbo modal" do
      visit project_path(project)

      click_link "Add Task"

      expect(page).to have_css("turbo-frame#modal")
      expect(page).to have_content("New task for #{project.title}")

      fill_in "Title", with: "Write system spec"
      fill_in "Description", with: "Cover Turbo modal task creation"

      click_button "Create Task"

      aggregate_failures do
        expect(page).to have_content("Write system spec")
        expect(page).to have_css("#tasks_to_do_count", text: "1")
        expect(page).to have_css("#tasks_to_do_empty_state", visible: :hidden)
        expect(page).to have_no_content("New task for #{project.title}")
      end
    end

    it "shows validation errors inside the turbo modal" do
      visit project_path(project)

      click_link "Add Task"

      fill_in "Description", with: "Description without title"

      expect do
        click_button "Create Task"
      end.not_to change(Task, :count)

      aggregate_failures do
        expect(page).to have_content("New task for #{project.title}")
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_css("turbo-frame#modal")
      end
    end
  end
end
