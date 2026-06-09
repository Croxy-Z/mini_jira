# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task do
  describe "associations" do
    it { is_expected.to belong_to(:project) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
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
