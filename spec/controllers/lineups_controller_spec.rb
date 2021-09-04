# frozen_string_literal: true

require "rails_helper"

RSpec.describe LineupsController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team: team) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  let(:valid_attributes) { { name: "Name" } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET #index" do
    context "for an admin" do
      before { sign_in(admin) }

      before { Fabricate(:lineup, team: team) }

      it "returns a success response" do
        get :index, params: { team_id: team.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      before { Fabricate(:lineup, team: team) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }

        it "returns a success response" do
          get :index, params: { team_id: team.to_param }
          expect(response).to be_successful
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }

        it "returns a success response" do
          get :index, params: { team_id: team.to_param }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "GET #show" do
    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :show, params: { team_id: team.to_param, id: lineup.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }

        it "returns a success response" do
          get :show, params: { team_id: team.to_param, id: lineup.to_param }
          expect(response).to be_successful
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }

        it "returns a success response" do
          get :show, params: { team_id: team.to_param, id: lineup.to_param }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "GET #new" do
    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :new, params: { team_id: team.to_param }
        expect(response).to be_successful
      end
    end

    context "for an user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }

        it "returns a success response" do
          get :new, params: { team_id: team.to_param }
          expect(response).to be_successful
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }

        it "redirects to unauthorized" do
          get :new, params: { team_id: team.to_param }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end

  describe "GET #edit" do
    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :edit, params: { team_id: team.to_param, id: lineup.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }

        it "returns a success response" do
          get :edit, params: { team_id: team.to_param, id: lineup.to_param }
          expect(response).to be_successful
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }

        it "redirects to unauthorized" do
          get :edit, params: { team_id: team.to_param, id: lineup.to_param }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end

  describe "POST #create" do
    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params with dh" do
        before { valid_attributes.merge!(with_dh: true) }

        it "creates a new Lineup" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    lineup: valid_attributes }
          end.to change(Lineup, :count).by(1)
        end

        it "doesn't create a pitcher spot" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    lineup: valid_attributes }
          end.not_to change(Spot, :count)
        end

        it "redirects to the Lineup list" do
          post :create, params: { team_id: team.to_param,
                                  lineup: valid_attributes }
          expect(response).to redirect_to(team_lineup_url(team, Lineup.last))
        end
      end

      context "when valid params without dh" do
        before { valid_attributes.merge!(with_dh: false) }

        it "creates a new Lineup" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    lineup: valid_attributes }
          end.to change(Lineup, :count).by(1)
        end

        it "creates a pitcher spot" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    lineup: valid_attributes }
          end.to change(Spot, :count).by(1)
        end

        it "redirects to the Lineup list" do
          post :create, params: { team_id: team.to_param,
                                  lineup: valid_attributes }
          expect(response).to redirect_to(team_lineup_url(team, Lineup.last))
        end
      end

      context "when valid params with 'all' vs" do
        before { valid_attributes.merge!(vs: "all") }

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
        before { Fabricate(:lineup, team: team, name: "") }

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

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }

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
          before { Fabricate(:lineup, team: team, name: "") }

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

      context "when not their team" do
        let(:team) { Fabricate(:team) }

        it "doesn't create a new Lineup" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    lineup: valid_attributes }
          end.not_to change(Lineup, :count)
        end

        it "redirects to unauthorized" do
          post :create, params: { team_id: team.to_param,
                                  lineup: valid_attributes }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end

  describe "PUT #update" do
    context "for an admin" do
      before { sign_in(admin) }

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
        before { Fabricate(:lineup, team: team, name: "") }

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

      context "when with_dh changes to true" do
        let!(:lineup) { Fabricate(:lineup, team: team, with_dh: false) }

        let(:valid_attributes) { { with_dh: true } }

        it "updates the requested Lineup" do
          expect do
            put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                   lineup: valid_attributes }
            lineup.reload
          end.to change(lineup, :with_dh).to(true)
        end

        it "destroys the pitcher's spot" do
          Fabricate(:spot, lineup: lineup, position: 2, batting_order: 3)
          expect do
            put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                   lineup: valid_attributes }
          end.to change(Spot, :count).by(-1)
        end

        it "redirects to the Lineup" do
          put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                 lineup: valid_attributes }
          expect(response).to redirect_to(team_lineup_url(team, lineup))
        end
      end

      context "when with_dh changes to false" do
        let!(:lineup) { Fabricate(:lineup, team: team, with_dh: true) }

        let(:valid_attributes) { { with_dh: false } }

        it "updates the requested Lineup" do
          expect do
            put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                   lineup: valid_attributes }
            lineup.reload
          end.to change(lineup, :with_dh).to(false)
        end

        it "removes the DH spot" do
          Fabricate(:spot, lineup: lineup, position: 2, batting_order: 3)
          Fabricate(:spot, lineup: lineup, position: 9, batting_order: 5)
          expect do
            put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                   lineup: valid_attributes }
          end.to change(Spot, :count).by(0)
        end

        it "adds pitcher spot" do
          Fabricate(:spot, lineup: lineup, position: 2, batting_order: 3)
          expect do
            put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                   lineup: valid_attributes }
          end.to change(Spot, :count).by(1)
        end

        it "redirects to the Lineup" do
          put :update, params: { team_id: team.to_param, id: lineup.to_param,
                                 lineup: valid_attributes }
          expect(response).to redirect_to(team_lineup_url(team, lineup))
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }

        context "when valid params" do
          it "updates the requested Lineup" do
            expect do
              put :update, params: { team_id: team.to_param,
                                     id: lineup.to_param,
                                     lineup: valid_attributes }
              lineup.reload
            end.to change(lineup, :name)
          end

          it "redirects to the Lineup" do
            put :update, params: { team_id: team.to_param,
                                   id: lineup.to_param,
                                   lineup: valid_attributes }
            expect(response).to redirect_to(team_lineup_url(team, lineup))
          end
        end

        context "when invalid params" do
          before { Fabricate(:lineup, team: team, name: "") }

          it "doesn't create a new Lineup" do
            expect do
              put :update, params: { team_id: team.to_param,
                                     id: lineup.to_param,
                                     lineup: invalid_attributes }
              lineup.reload
            end.not_to change(lineup, :name)
          end

          it "renders edit" do
            put :update, params: { team_id: team.to_param,
                                   id: lineup.to_param,
                                   lineup: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }

        before { Fabricate(:lineup, team: team, name: "") }

        it "doesn't create a new Lineup" do
          expect do
            put :update, params: { team_id: team.to_param,
                                   id: lineup.to_param,
                                   lineup: invalid_attributes }
            lineup.reload
          end.not_to change(lineup, :name)
        end

        it "redirects to unauthorized" do
          put :update, params: { team_id: team.to_param,
                                 id: lineup.to_param,
                                 lineup: invalid_attributes }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { lineup }

    context "for an admin" do
      before { sign_in(admin) }

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

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }

        it "destroys the requested Lineup" do
          expect do
            delete :destroy,
                   params: { team_id: team.to_param,
                             id: lineup.to_param }
          end.to change(Lineup, :count).by(-1)
        end

        it "redirects to the Lineup list" do
          delete :destroy, params: { team_id: team.to_param,
                                     id: lineup.to_param }
          expect(response).to redirect_to(team_lineups_url(team))
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }

        it "destroys the requested Lineup" do
          expect do
            delete :destroy,
                   params: { team_id: team.to_param,
                             id: lineup.to_param }
          end.not_to change(Lineup, :count)
        end

        it "redirects to unauthorized" do
          delete :destroy, params: { team_id: team.to_param,
                                     id: lineup.to_param }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end
end
