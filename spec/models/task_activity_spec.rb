# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskActivity do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:task) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:action) }
    it { is_expected.to validate_inclusion_of(:action).in_array([TaskActivity::ACTION_MOVED]) }

    it { is_expected.to validate_presence_of(:from_status) }
    it { is_expected.to validate_inclusion_of(:from_status).in_array(Task.statuses.keys) }

    it { is_expected.to validate_presence_of(:to_status) }
    it { is_expected.to validate_inclusion_of(:to_status).in_array(Task.statuses.keys) }
  end
end
