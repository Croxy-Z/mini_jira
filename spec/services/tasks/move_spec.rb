# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tasks::Move do
  describe ".call" do
    subject(:result) { described_class.call(task:, actor:, new_status:) }

    let(:project) { create(:project) }
    let(:actor) { project.user }
    let(:task) { create(:task, project:, status: :to_do) }
    let(:new_status) { "done" }

    context "when status is valid" do
      it "moves the task to the new status" do
        expect { result }.to change { task.reload.status }.from("to_do").to("done")
      end

      it "creates task activity" do
        expect { result }.to change(TaskActivity, :count).by(1)

        activity = TaskActivity.last

        aggregate_failures do
          expect(activity.user).to eq(actor)
          expect(activity.project).to eq(project)
          expect(activity.task).to eq(task)
          expect(activity.action).to eq(TaskActivity::ACTION_MOVED)
          expect(activity.from_status).to eq("to_do")
          expect(activity.to_status).to eq("done")
        end
      end

      it "returns a successful result" do
        aggregate_failures do
          expect(result).to be_success
          expect(result.task).to eq(task)
          expect(result.error_code).to be_nil
          expect(result.errors).to be_empty
        end
      end
    end

    context "when status is invalid" do
      let(:new_status) { "archived" }

      it "does not change the task status" do
        expect { result }.not_to(change { task.reload.status })
      end

      it "does not create task activity" do
        expect { result }.not_to change(TaskActivity, :count)
      end

      it "returns an invalid status error" do
        aggregate_failures do
          expect(result).not_to be_success
          expect(result.task).to eq(task)
          expect(result.error_code).to eq(:invalid_status)
          expect(result.errors).to be_empty
        end
      end
    end

    context "when status does not change" do
      let(:new_status) { "to_do" }

      it "does not create task activity" do
        expect { result }.not_to change(TaskActivity, :count)
      end

      it "returns success" do
        expect(result).to be_success
      end
    end
  end
end
