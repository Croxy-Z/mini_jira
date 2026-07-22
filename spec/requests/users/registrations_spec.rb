# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User registrations" do
  describe "PATCH /users" do
    context "when the current user is the demo user" do
      let(:user) { create(:user, email: User::DEMO_EMAIL) }

      before { sign_in user }

      it "does not update the account" do
        patch user_registration_path, params: {
          user: {
            email: "changed@example.com",
            current_password: user.password
          }
        }

        expect(user.reload.email).to eq(User::DEMO_EMAIL)
      end

      it "redirects with an alert" do
        patch user_registration_path, params: {
          user: {
            email: "changed@example.com",
            current_password: user.password
          }
        }

        expect(response).to redirect_to(authenticated_root_path)
        expect(flash[:alert]).to eq("Demo account settings are protected.")
      end
    end

    context "when the current user is not the demo user" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "allows the account to be updated" do
        patch user_registration_path, params: {
          user: {
            email: "changed@example.com",
            current_password: user.password
          }
        }

        expect(user.reload.email).to eq("changed@example.com")
      end
    end
  end

  describe "DELETE /users" do
    context "when the current user is the demo user" do
      let!(:user) { create(:user, email: User::DEMO_EMAIL) }

      before { sign_in user }

      it "does not delete the account" do
        expect {
          delete user_registration_path
        }.not_to change(User, :count)
      end

      it "redirects with an alert" do
        delete user_registration_path

        expect(response).to redirect_to(authenticated_root_path)
        expect(flash[:alert]).to eq("Demo account settings are protected.")
      end
    end

    context "when the current user is not the demo user" do
      let!(:user) { create(:user) }

      before { sign_in user }

      it "deletes the account" do
        expect {
          delete user_registration_path
        }.to change(User, :count).by(-1)
      end
    end
  end
end
