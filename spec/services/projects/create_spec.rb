# frozen_string_literal: true

require "rails_helper"

RSpec.describe Projects::Create do
  describe ".call" do
    subject(:result) { described_class.call(user:, params:) }

    let(:user) { create(:user) }
    let(:params) { { title: "My Project", description: "Test description" } }

    context "when params are valid" do
      it "creates a project" do
        expect do
          described_class.call(user:, params:)
        end.to change(Project, :count).by(1)
      end

      it "returns a successful result with the created project" do
        aggregate_failures do
          expect(result).to be_success
          expect(result.project).to be_persisted
          expect(result.project.title).to eq("My Project")
          expect(result.project.user).to eq(user)
        end
      end
    end

    context "when params are invalid" do
      let(:params) { { title: "", description: "Test description" } }

      it "does not create a project" do
        expect do
          described_class.call(user:, params:)
        end.not_to change(Project, :count)
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
