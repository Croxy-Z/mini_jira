# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tasks::Move do
  describe ".call" do
    subject(:result) { described_class.call(task:, new_status:) }

    let(:project) { create(:project) }
    let(:task) { create(:task, project:, status: :to_do) }
    let(:new_status) { "done" }

    context "when status is valid" do
      it "moves the task to the new status" do
        expect { result }.to change { task.reload.status }.from("to_do").to("done")
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

      it "returns an invalid status error" do
        aggregate_failures do
          expect(result).not_to be_success
          expect(result.task).to eq(task)
          expect(result.error_code).to eq(:invalid_status)
          expect(result.errors).to be_empty
        end
      end
    end
  end
end
