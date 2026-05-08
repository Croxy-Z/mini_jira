# frozen_string_literal: true

require "rails_helper"

RSpec.describe Projects::CreateService do
  describe "#call" do
    let(:user) { create(:user) }
    let(:valid_params) { { title: "My Super Project", description: "Test description" } }
    let(:invalid_params) { { title: "", description: "Test description" } }

    context "when parameters are valid" do
      it "creates a new project in the database" do
        expect do
          described_class.new(user:, params: valid_params).call
        end.to change(Project, :count).by(1)
      end

      it "returns a successful result with the project" do
        result = described_class.new(user:, params: valid_params).call

        expect(result.success?).to be true
        expect(result.project.title).to eq("My Super Project")
        expect(result.project.user).to eq(user)
      end
    end

    context "when parameters are invalid" do
      it "does not create a project" do
        expect do
          described_class.new(user:, params: invalid_params).call
        end.not_to change(Project, :count)
      end

      it "returns a failed result" do
        result = described_class.new(user:, params: invalid_params).call

        expect(result.success?).to be false
        expect(result.project.errors).not_to be_empty
      end
    end
  end
end
