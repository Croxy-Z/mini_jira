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

  describe "database constraints" do
    it "does not allow a null role" do
      expect(described_class.columns_hash["role"].null).to be_falsy
    end
  end

  describe "welcome email" do
    it "enqueues welcome email after user creation" do
      expect do
        create(:user)
      end.to have_enqueued_mail(UserMailer, :welcome_email)
    end
  end
end
