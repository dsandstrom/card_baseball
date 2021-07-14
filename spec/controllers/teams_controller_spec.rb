# frozen_string_literal: true

require "rails_helper"

RSpec.describe TeamsController, type: :controller do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league: league) }

  let(:valid_attributes) { { name: "Name", identifier: "ID" } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { league_id: league.to_param,
                           id: team.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: { league_id: league.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { league_id: league.to_param,
                           id: team.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "when valid params" do
      it "creates a new Team" do
        expect do
          post :create, params: { league_id: league.to_param,
                                  team: valid_attributes }
        end.to change(Team, :count).by(1)
      end

      it "redirects to the Team list" do
        post :create, params: { league_id: league.to_param,
                                team: valid_attributes }
        expect(response).to redirect_to(league)
      end
    end

    context "when invalid params" do
      it "doesn't create a new Team" do
        expect do
          post :create, params: { league_id: league.to_param,
                                  team: invalid_attributes }
        end.not_to change(Team, :count)
      end

      it "renders new" do
        post :create, params: { league_id: league.to_param,
                                team: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "when valid params" do
      it "updates the requested Team" do
        expect do
          put :update, params: { league_id: league.to_param,
                                 id: team.to_param,
                                 team: valid_attributes }
          team.reload
        end.to change(team, :name)
      end

      it "redirects to the Team" do
        put :update, params: { league_id: league.to_param,
                               id: team.to_param,
                               team: valid_attributes }
        expect(response).to redirect_to(league_team_path(league, team))
      end
    end

    context "when invalid params" do
      it "doesn't change the requested Team's name" do
        expect do
          put :update, params: { league_id: league.to_param,
                                 id: team.to_param,
                                 team: invalid_attributes }
          team.reload
        end.not_to change(team, :name)
      end

      it "renders edit" do
        put :update, params: { league_id: league.to_param,
                               id: team.to_param,
                               team: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    before { team }

    it "destroys the requested Team" do
      expect do
        delete :destroy, params: { league_id: league.to_param,
                                   id: team.to_param }
      end.to change(Team, :count).by(-1)
    end

    it "redirects to the Team list" do
      delete :destroy, params: { league_id: league.to_param,
                                 id: team.to_param }
      expect(response).to redirect_to(league)
    end
  end
end
