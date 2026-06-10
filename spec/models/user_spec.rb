# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "associations" do
    it { is_expected.to have_many(:projects).dependent(:destroy) }
  end

  describe "roles" do
    it do
      expect(described_class.roles).to eq(
        "user" => 0,
        "manager" => 1,
        "admin" => 2
      )
    end
  end
end
