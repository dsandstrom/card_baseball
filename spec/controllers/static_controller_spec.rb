# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaticController, type: :controller do
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "GET #unauthorized" do
    context "for a guest" do
      it "returns a success response" do
        get :unauthorized
        expect(response).to redirect_to(:new_user_session)
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :unauthorized
        expect(response).to be_successful
      end
    end

    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :unauthorized
        expect(response).to be_successful
      end
    end
  end

  describe "GET #sitemap" do
    context "for a guest" do
      it "returns a success response" do
        get :sitemap
        expect(response).to redirect_to(:new_user_session)
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :sitemap
        expect(response).to be_successful
      end
    end

    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :sitemap
        expect(response).to be_successful
      end
    end
  end
end
