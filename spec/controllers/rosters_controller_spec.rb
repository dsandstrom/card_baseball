# frozen_string_literal: true

require "rails_helper"

RSpec.describe RostersController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:roster) { Fabricate(:roster, team: team) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:player) { Fabricate(:pitcher) }

  before { Fabricate(:contract, team: team, player: player) }

  let(:valid_attributes) do
    { player_id: player.to_param, level: "2", position: "1" }
  end

  let(:invalid_attributes) { { player_id: player.to_param, level: "" } }

  describe "GET #index" do
    context "for an admin" do
      before { sign_in(admin) }

      before { Fabricate(:roster, team: team) }

      it "returns a success response" do
        get :index, params: { team_id: team.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      before { Fabricate(:roster, team: team) }

      context "when their team" do
        before { team.update(user_id: user.id) }

        it "returns a success response" do
          get :index, params: { team_id: team.to_param }
          expect(response).to be_successful
        end
      end

      context "when not their team" do
        it "returns a success response" do
          get :index, params: { team_id: team.to_param }
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
        before { team.update(user_id: user.id) }

        it "returns a success response" do
          get :new, params: { team_id: team.to_param }
          expect(response).to be_successful
        end
      end

      context "when not their team" do
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
        get :edit, params: { team_id: team.to_param, id: roster.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        before { team.update(user_id: user.id) }

        it "returns a success response" do
          get :edit, params: { team_id: team.to_param, id: roster.to_param }
          expect(response).to be_successful
        end
      end

      context "when not their team" do
        it "redirects to unauthorized" do
          get :edit, params: { team_id: team.to_param, id: roster.to_param }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end

  describe "POST #create" do
    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params" do
        it "creates a new Roster" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    roster: valid_attributes }
          end.to change(Roster, :count).by(1)
        end

        it "redirects to the Roster list" do
          post :create, params: { team_id: team.to_param,
                                  roster: valid_attributes }
          expect(response).to redirect_to(team_rosters_url(team))
        end
      end

      context "when invalid params" do
        it "doesn't create a new Roster" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    roster: invalid_attributes }
          end.not_to change(Roster, :count)
        end

        it "renders new" do
          post :create, params: { team_id: team.to_param,
                                  roster: invalid_attributes }
          expect(response).to be_successful
        end
      end

      context "when player already has a roster" do
        before do
          Fabricate(:roster, team: team, level: 1, position: 1, player: player)
        end

        context "when valid params" do
          it "destroys old Roster and creates a new Roster" do
            expect do
              post :create, params: { team_id: team.to_param,
                                      roster: valid_attributes }
            end.not_to change(Roster, :count)
          end

          it "redirects to the Roster list" do
            post :create, params: { team_id: team.to_param,
                                    roster: valid_attributes }
            expect(response).to redirect_to(team_rosters_url(team))
          end
        end

        context "when invalid params" do
          it "doesn't create a new Roster" do
            expect do
              post :create, params: { team_id: team.to_param,
                                      roster: invalid_attributes }
            end.not_to change(Roster, :count)
          end

          it "renders new" do
            post :create, params: { team_id: team.to_param,
                                    roster: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "when player already has a roster for the current level" do
        before do
          Fabricate(:roster, team: team, player: player,
                             level: valid_attributes[:level],
                             position: valid_attributes[:position])
        end

        it "doesn't destroy old Roster" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    roster: valid_attributes }
          end.not_to change(Roster, :count)
        end

        it "redirects to the Roster list" do
          post :create, params: { team_id: team.to_param,
                                  roster: valid_attributes }
          expect(response).to redirect_to(team_rosters_url(team))
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        before { team.update(user_id: user.id) }

        context "when valid params" do
          it "creates a new Roster" do
            expect do
              post :create, params: { team_id: team.to_param,
                                      roster: valid_attributes }
            end.to change(Roster, :count).by(1)
          end

          it "redirects to the Roster list" do
            post :create, params: { team_id: team.to_param,
                                    roster: valid_attributes }
            expect(response).to redirect_to(team_rosters_url(team))
          end
        end

        context "when invalid params" do
          it "doesn't create a new Roster" do
            expect do
              post :create, params: { team_id: team.to_param,
                                      roster: invalid_attributes }
            end.not_to change(Roster, :count)
          end

          it "renders new" do
            post :create, params: { team_id: team.to_param,
                                    roster: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "when not their team" do
        it "doesn't create a new Roster" do
          expect do
            post :create, params: { team_id: team.to_param,
                                    roster: valid_attributes }
          end.not_to change(Roster, :count)
        end

        it "redirects to unauthorized" do
          post :create, params: { team_id: team.to_param,
                                  roster: valid_attributes }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end

  describe "PUT #update" do
    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params" do
        it "updates the requested Roster" do
          expect do
            put :update, params: { team_id: team.to_param, id: roster.to_param,
                                   roster: valid_attributes }
            roster.reload
          end.to change(roster, :level)
        end

        it "redirects to the Roster" do
          put :update, params: { team_id: team.to_param, id: roster.to_param,
                                 roster: valid_attributes }
          expect(response).to redirect_to(team_rosters_url(team))
        end
      end

      context "when invalid params" do
        it "doesn't create a new Roster" do
          expect do
            put :update, params: { team_id: team.to_param, id: roster.to_param,
                                   roster: invalid_attributes }
            roster.reload
          end.not_to change(roster, :level)
        end

        it "renders edit" do
          put :update, params: { team_id: team.to_param, id: roster.to_param,
                                 roster: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        before { team.update(user_id: user.id) }

        context "when valid params" do
          it "updates the requested Roster" do
            expect do
              put :update, params: { team_id: team.to_param,
                                     id: roster.to_param,
                                     roster: valid_attributes }
              roster.reload
            end.to change(roster, :level)
          end

          it "redirects to the Roster" do
            put :update, params: { team_id: team.to_param,
                                   id: roster.to_param,
                                   roster: valid_attributes }
            expect(response).to redirect_to(team_rosters_url(team))
          end
        end

        context "when invalid params" do
          it "doesn't create a new Roster" do
            expect do
              put :update, params: { team_id: team.to_param,
                                     id: roster.to_param,
                                     roster: invalid_attributes }
              roster.reload
            end.not_to change(roster, :level)
          end

          it "renders edit" do
            put :update, params: { team_id: team.to_param,
                                   id: roster.to_param,
                                   roster: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "when not their team" do
        it "doesn't create a new Roster" do
          expect do
            put :update, params: { team_id: team.to_param,
                                   id: roster.to_param,
                                   roster: invalid_attributes }
            roster.reload
          end.not_to change(roster, :level)
        end

        it "redirects to unauthorized" do
          put :update, params: { team_id: team.to_param,
                                 id: roster.to_param,
                                 roster: invalid_attributes }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { roster }

    context "for an admin" do
      before { sign_in(admin) }

      it "destroys the requested Roster" do
        expect do
          delete :destroy,
                 params: { team_id: team.to_param, id: roster.to_param }
        end.to change(Roster, :count).by(-1)
      end

      it "redirects to the Roster list" do
        delete :destroy, params: { team_id: team.to_param, id: roster.to_param }
        expect(response).to redirect_to(team_rosters_url(team))
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        before { team.update(user_id: user.id) }

        it "destroys the requested Roster" do
          expect do
            delete :destroy,
                   params: { team_id: team.to_param,
                             id: roster.to_param }
          end.to change(Roster, :count).by(-1)
        end

        it "redirects to the Roster list" do
          delete :destroy, params: { team_id: team.to_param,
                                     id: roster.to_param }
          expect(response).to redirect_to(team_rosters_url(team))
        end
      end

      context "when not their team" do
        it "destroys the requested Roster" do
          expect do
            delete :destroy,
                   params: { team_id: team.to_param,
                             id: roster.to_param }
          end.not_to change(Roster, :count)
        end

        it "redirects to unauthorized" do
          delete :destroy, params: { team_id: team.to_param,
                                     id: roster.to_param }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end
end
