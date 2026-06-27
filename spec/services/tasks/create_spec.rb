# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tasks::Create do
  describe ".call" do
    subject(:result) { described_class.call(task:) }

    let(:project) { create(:project) }

    context "when params are valid" do
      let(:task) { build(:task, project:) }

      it "creates a task" do
        expect { described_class.call(task:) }.to change(Task, :count).by(1)
      end

      it "returns a successful result with the created task" do
        aggregate_failures do
          expect(result).to be_success
          expect(result.task).to be_persisted
          expect(result.task.project).to eq(project)
        end
      end
    end

    context "when params are invalid" do
      let(:task) { build(:task, project:, title: "") }

      it "does not create a task" do
        expect { described_class.call(task:) }.not_to change(Task, :count)
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
