# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpotsController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:hitter) { Fabricate(:hitter) }
  let(:lineup) { Fabricate(:lineup, team: team) }
  let(:spot) { Fabricate(:spot, lineup: lineup) }

  before do
    Fabricate(:hitter_contract, hitter: hitter, team: team)
  end

  let(:valid_attributes) do
    { hitter_id: hitter.to_param, position: 2, batting_order: 2 }
  end
  let(:invalid_attributes) { { batting_order: "" } }

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: { lineup_id: lineup.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { lineup_id: lineup.to_param,
                           id: spot.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "when valid params" do
      it "creates a new Spot" do
        expect do
          post :create, params: { lineup_id: lineup.to_param,
                                  spot: valid_attributes }
        end.to change(Spot, :count).by(1)
      end

      it "redirects to the Spot list" do
        post :create, params: { lineup_id: lineup.to_param,
                                spot: valid_attributes }
        expect(response).to redirect_to(team_lineup_path(team, lineup))
      end
    end

    context "when invalid params" do
      it "doesn't create a new Spot" do
        expect do
          post :create, params: { lineup_id: lineup.to_param,
                                  spot: invalid_attributes }
        end.not_to change(Spot, :count)
      end

      it "renders new" do
        post :create, params: { lineup_id: lineup.to_param,
                                spot: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "when valid params" do
      it "updates the requested Spot" do
        expect do
          put :update, params: { lineup_id: lineup.to_param,
                                 id: spot.to_param,
                                 spot: valid_attributes }
          spot.reload
        end.to change(spot, :batting_order)
      end

      it "redirects to the Spot" do
        put :update, params: { lineup_id: lineup.to_param,
                               id: spot.to_param,
                               spot: valid_attributes }
        expect(response).to redirect_to(team_lineup_path(team, lineup))
      end
    end

    context "when invalid params" do
      it "doesn't change the requested Spot's name" do
        expect do
          put :update, params: { lineup_id: lineup.to_param,
                                 id: spot.to_param,
                                 spot: invalid_attributes }
          spot.reload
        end.not_to change(spot, :batting_order)
      end

      it "renders edit" do
        put :update, params: { lineup_id: lineup.to_param,
                               id: spot.to_param,
                               spot: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    before { spot }

    it "destroys the requested Spot" do
      expect do
        delete :destroy, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param }
      end.to change(Spot, :count).by(-1)
    end

    it "redirects to the Spot list" do
      delete :destroy, params: { lineup_id: lineup.to_param,
                                 id: spot.to_param }
      expect(response).to redirect_to(team_lineup_path(team, lineup))
    end
  end
end
