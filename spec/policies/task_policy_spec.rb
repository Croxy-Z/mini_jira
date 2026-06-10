# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskPolicy do
  subject(:policy) { described_class.new(user, task) }

  let(:owner) { build_stubbed(:user) }
  let(:project) { build_stubbed(:project, user: owner) }
  let(:task) { build_stubbed(:task, project:) }

  describe "owner/admin actions" do
    let(:actions) { %i[show create edit update destroy] }

    context "when user owns the task project" do
      let(:user) { owner }

      it { is_expected.to permit_actions(actions) }
    end

    context "when user does not own the task project" do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to forbid_actions(actions) }
    end

    context "when user is admin" do
      let(:user) { build_stubbed(:user, :admin) }

      it { is_expected.to permit_actions(actions) }
    end
  end

  describe "Scope" do
    subject(:resolved_scope) { described_class::Scope.new(user, Task.all).resolve }

    let(:scope_user) { create(:user) }
    let(:own_project) { create(:project, user: scope_user) }
    let(:other_project) { create(:project) }

    let!(:own_task) { create(:task, project: own_project) }
    let!(:other_task) { create(:task, project: other_project) }

    context "when user is nil" do
      let(:user) { nil }

      it "returns no tasks" do
        expect(resolved_scope).to be_empty
      end
    end

    context "when user is regular user" do
      let(:user) { scope_user }

      it "returns only tasks from user's projects" do
        expect(resolved_scope).to contain_exactly(own_task)
      end
    end

    context "when user is admin" do
      let(:user) { create(:user, :admin) }

      it "returns all tasks" do
        expect(resolved_scope).to contain_exactly(own_task, other_task)
      end
    end
  end
end
