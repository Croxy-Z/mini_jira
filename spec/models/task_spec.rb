# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
  end

  describe "validations" do
    let(:project) { create(:project) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(160) }
    it { is_expected.to validate_length_of(:description).is_at_most(2000) }

    it "defaults status to to_do at the database level" do
      described_class.insert_all!(
        [
          {
            project_id: project.id,
            title: "Task with database default",
            created_at: Time.current,
            updated_at: Time.current
          }
        ]
      )

      task = described_class.find_by!(title: "Task with database default")

      expect(task.status).to eq("to_do")
    end
  end

  describe "status" do
    it do
      expect(described_class.statuses).to eq(
        "to_do" => 0,
        "in_progress" => 1,
        "done" => 2
      )
    end
  end
end
