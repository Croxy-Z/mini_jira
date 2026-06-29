# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskColumnComponent, type: :component do
  subject(:rendered_component) do
    render_inline(described_class.new(title:, status:, tasks:, project:))
  end

  let(:project) { create(:project) }
  let(:status) { "to_do" }
  let(:title) { "To Do" }
  let(:tasks) { build_stubbed_list(:task, 2, project:, status:) }

  it "renders the column with counter and task container ids" do
    rendered_component

    aggregate_failures do
      expect(page).to have_css("#tasks_to_do")
      expect(page).to have_css("#tasks_to_do_count", text: "2")
      expect(page).to have_css("#tasks_to_do_empty_state", visible: :hidden)
    end
  end

  context "when the column has no tasks" do
    let(:tasks) { [] }

    it "renders the empty state" do
      rendered_component

      aggregate_failures do
        expect(page).to have_css("#tasks_to_do_count", text: "0")
        expect(page).to have_css("#tasks_to_do_empty_state", text: "No tasks yet")
      end
    end
  end
end
