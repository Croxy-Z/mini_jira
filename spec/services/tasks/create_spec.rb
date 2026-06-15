# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tasks::Create do
  describe ".call" do
    subject(:result) { described_class.call(project:, params:) }

    let(:project) { create(:project) }
    let(:params) { { title: "My Task", description: "Test description" } }

    context "when params are valid" do
      it "creates a task" do
        expect do
          described_class.call(project:, params:)
        end.to change(Task, :count).by(1)
      end

      it "returns a successful result with the created task" do
        aggregate_failures do
          expect(result).to be_success
          expect(result.task).to be_persisted
          expect(result.task.title).to eq("My Task")
          expect(result.task.project).to eq(project)
        end
      end
    end

    context "when params are invalid" do
      let(:params) { { title: "", description: "Test description" } }

      it "does not create a task" do
        expect do
          described_class.call(project:, params:)
        end.not_to change(Task, :count)
      end

      it "returns a failed result with task errors" do
        aggregate_failures do
          expect(result).not_to be_success
          expect(result.task).not_to be_persisted
          expect(result.task.errors).not_to be_empty
        end
      end
    end
  end
end
