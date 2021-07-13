# frozen_string_literal: true

require "rails_helper"

RSpec.describe HittersController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:hitter) { Fabricate(:hitter) }

  describe "GET #index" do
    before { Fabricate(:hitter) }

    context "when team" do
      before { Fabricate(:contract, team: team, player: hitter) }

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
