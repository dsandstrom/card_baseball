# frozen_string_literal: true

require "rails_helper"

RSpec.describe StaticController, type: :controller do
  let(:user) { Fabricate(:user) }

  describe "GET #unauthorized" do
    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :unauthorized
        expect(response).to be_successful
      end
    end
  end
end
