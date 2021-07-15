# frozen_string_literal: true

require "rails_helper"

RSpec.describe LineupsController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team: team) }
  let(:user) { Fabricate(:user) }

  let(:valid_attributes) { { name: "Name" } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET #index" do
    context "for a user" do
      before { sign_in(user) }

      before { Fabricate(:lineup, team: team) }

      it "returns a success response" do
        get :index, params: { team_id: team.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :show, params: { team_id: team.to_param, id: lineup.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #new" do
    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :new, params: { team_id: team.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :edit, params: { team_id: team.to_param, id: lineup.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "POST #create" do
    context "for a user" do
      before { sign_in(user) }

      context "when valid params" do
        it "creates a new Lineup" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    lineup: valid_attributes }
          end.to change(Lineup, :count).by(1)
        end

        it "redirects to the Lineup list" do
          post :create, params: { team_id: team.to_param,
                                  lineup: valid_attributes }
          expect(response).to redirect_to(team_lineup_url(team, Lineup.last))
        end
      end

      context "when invalid params" do
        it "doesn't create a new Lineup" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    lineup: invalid_attributes }
          end.not_to change(Lineup, :count)
        end

        it "renders new" do
          post :create, params: { team_id: team.to_param,
                                  lineup: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "PUT #update" do
    context "for a user" do
      before { sign_in(user) }

      context "when valid params" do
        it "updates the requested Lineup" do
          expect do
            put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                   lineup: valid_attributes }
            lineup.reload
          end.to change(lineup, :name)
        end

        it "redirects to the Lineup" do
          put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                 lineup: valid_attributes }
          expect(response).to redirect_to(team_lineup_url(team, lineup))
        end
      end

      context "when invalid params" do
        it "doesn't create a new Lineup" do
          expect do
            put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                   lineup: invalid_attributes }
            lineup.reload
          end.not_to change(lineup, :name)
        end

        it "renders edit" do
          put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                 lineup: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { lineup }

    context "for a user" do
      before { sign_in(user) }

      it "destroys the requested Lineup" do
        expect do
          delete :destroy,
                 params: { team_id: team.to_param, id: lineup.to_param }
        end.to change(Lineup, :count).by(-1)
      end

      it "redirects to the Lineup list" do
        delete :destroy, params: { team_id: team.to_param, id: lineup.to_param }
        expect(response).to redirect_to(team_lineups_url(team))
      end
    end
  end
end
