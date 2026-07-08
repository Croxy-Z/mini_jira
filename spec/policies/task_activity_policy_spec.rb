# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskActivityPolicy do
  subject(:policy) { described_class.new(user, task_activity) }

  let(:project) { create(:project) }
  let(:task) { create(:task, project:) }
  let(:task_activity) { create(:task_activity, task:, project:, user: project.user) }

  context "when user owns the project" do
    let(:user) { project.user }

    it "permits show" do
      expect(policy).to permit_action(:show)
    end
  end

  context "when user does not own the project" do
    let(:user) { create(:user) }

    it "forbids show" do
      expect(policy).to forbid_action(:show)
    end
  end

  context "when user is admin" do
    let(:user) { create(:user, :admin) }

    it "permits show" do
      expect(policy).to permit_action(:show)
    end
  end

  describe "Scope" do
    subject(:resolved_scope) { described_class::Scope.new(user, TaskActivity).resolve }

    let(:own_project) { create(:project, user:) }
    let(:own_task) { create(:task, project: own_project) }
    let!(:own_activity) { create(:task_activity, task: own_task, project: own_project, user:) }

    let(:other_project) { create(:project) }
    let(:other_task) { create(:task, project: other_project) }
    let!(:other_activity) do
      create(:task_activity, task: other_task, project: other_project, user: other_project.user)
    end

    context "when user is a regular user" do
      let(:user) { create(:user) }

      it "returns only activities from user's projects" do
        expect(resolved_scope).to contain_exactly(own_activity)
      end
    end

    context "when user is admin" do
      let(:user) { create(:user, :admin) }

      it "returns all activities" do
        expect(resolved_scope).to contain_exactly(own_activity, other_activity)
      end
    end
  end
end
