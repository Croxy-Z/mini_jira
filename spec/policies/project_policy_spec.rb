# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProjectPolicy do
  subject(:policy) { described_class.new(user, project) }

  let(:owner) { build_stubbed(:user) }
  let(:project) { build_stubbed(:project, user: owner) }

  describe "authentication actions" do
    let(:actions) { %i[index new create] }

    context "when user is present" do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to permit_actions(actions) }
    end

    context "when user is nil" do
      let(:user) { nil }

      it { is_expected.to forbid_actions(actions) }
    end
  end

  describe "owner/admin actions" do
    let(:actions) { %i[show edit update destroy] }

    context "when user owns the project" do
      let(:user) { owner }

      it { is_expected.to permit_actions(actions) }
    end

    context "when user does not own the project" do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to forbid_actions(actions) }
    end

    context "when user is admin" do
      let(:user) { build_stubbed(:user, :admin) }

      it { is_expected.to permit_actions(actions) }
    end
  end

  describe "Scope" do
    subject(:resolved_scope) { described_class::Scope.new(user, Project.all).resolve }

    let(:scope_user) { create(:user) }
    let!(:own_project) { create(:project, user: scope_user) }
    let!(:other_project) { create(:project) }

    context "when user is nil" do
      let(:user) { nil }

      it "returns no projects" do
        expect(resolved_scope).to be_empty
      end
    end

    context "when user is regular user" do
      let(:user) { scope_user }

      it "returns only user's projects" do
        expect(resolved_scope).to contain_exactly(own_project)
      end
    end

    context "when user is admin" do
      let(:user) { create(:user, :admin) }

      it "returns all projects" do
        expect(resolved_scope).to contain_exactly(own_project, other_project)
      end
    end
  end
end
