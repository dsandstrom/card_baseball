# frozen_string_literal: true

require "rails_helper"

RSpec.describe HittersController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:hitter) { Fabricate(:hitter) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  describe "GET #index" do
    context "for an admin" do
      before { sign_in(admin) }

      before { Fabricate(:hitter) }

      context "when team" do
        before { Fabricate(:contract, team:, player: hitter) }

        it "returns a success response" do
          get :index, params: { team_id: team.to_param }
          expect(response).to be_successful
        end
      end

      context "when no team" do
        it "returns a success response" do
          get :index
          expect(response).to be_successful
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      before { Fabricate(:hitter) }

      context "when team" do
        before { Fabricate(:contract, team:, player: hitter) }

        it "returns a success response" do
          get :index, params: { team_id: team.to_param }
          expect(response).to be_successful
        end
      end

      context "when no team" do
        it "returns a success response" do
          get :index
          expect(response).to be_successful
        end
      end
    end
  end
end
