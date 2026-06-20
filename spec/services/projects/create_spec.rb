# frozen_string_literal: true
require "rails_helper"

RSpec.describe Projects::Create do
  describe ".call" do
    subject(:result) { described_class.call(project:) }

    let(:user) { create(:user) }

    context "when params are valid" do
      let(:project) { build(:project, user:) }

      it "creates a project" do
        expect { described_class.call(project:) }.to change(Project, :count).by(1)
      end

      it "returns a successful result with the created project" do
        aggregate_failures do
          expect(result).to be_success
          expect(result.project).to be_persisted
          expect(result.project.user).to eq(user)
        end
      end
    end

    context "when params are invalid" do
      let(:project) { build(:project, user:, title: "") }

      it "does not create a project" do
        expect { described_class.call(project:) }.not_to change(Project, :count)
      end

      it "returns a failed result with project errors" do
        aggregate_failures do
          expect(result).not_to be_success
          expect(result.project).not_to be_persisted
          expect(result.project.errors).not_to be_empty
        end
      end
    end
  end
end
