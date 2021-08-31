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

      context "for an HTML request" do
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
            Fabricate(:roster, team: team, level: 1, position: 1,
                               player: player)
          end

          context "when valid params" do
            it "destroys old Roster and creates a new Roster" do
              expect do
                post :create, params: { team_id: team.to_param,
                                        roster: valid_attributes }
              end.not_to change(Roster, :count)
            end

            it "renders new" do
              post :create, params: { team_id: team.to_param,
                                      roster: valid_attributes }
              expect(response).to be_successful
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

          it "renders new" do
            post :create, params: { team_id: team.to_param,
                                    roster: valid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "for a JS request" do
        before { invalid_attributes.merge(position: "1") }

        context "when player doesn't have a roster" do
          context "and no other players at position" do
            let(:js_attributes) do
              { player_id: player.to_param, level: "2", position: "1" }
            end

            context "when valid params" do
              it "creates a new Roster" do
                expect do
                  post :create, xhr: true,
                                params: { team_id: team.to_param,
                                          roster: js_attributes }
                end.to change(Roster, :count).by(1)
              end

              it "redirects to the Roster list" do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: js_attributes }
                expect(response).to redirect_to(team_rosters_url(team))
              end
            end

            context "when invalid params" do
              it "doesn't create a new Roster" do
                expect do
                  post :create, xhr: true,
                                params: { team_id: team.to_param,
                                          roster: invalid_attributes }
                end.not_to change(Roster, :count)
              end

              it "renders new" do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: invalid_attributes }
                expect(response).to be_successful
              end
            end
          end

          context "and 1 other player at position" do
            let(:other_player) { Fabricate(:pitcher) }

            before do
              Fabricate(:roster, team: team, level: 2, position: 1,
                                 player: other_player)
            end

            context "with valid params" do
              let(:js_attributes) do
                { player_id: player.to_param, level: "2", position: "1" }
              end

              it "creates a new Roster" do
                expect do
                  post :create, xhr: true,
                                params: { team_id: team.to_param,
                                          roster: js_attributes }
                end.to change(Roster, :count).by(1)
              end

              it "redirects to the Roster list" do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: js_attributes }
                expect(response).to redirect_to(team_rosters_url(team))
              end
            end

            context "when invalid params" do
              it "doesn't create a new Roster" do
                expect do
                  post :create, xhr: true,
                                params: { team_id: team.to_param,
                                          roster: invalid_attributes }
                end.not_to change(Roster, :count)
              end

              it "renders new" do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: invalid_attributes }
                expect(response).to be_successful
              end
            end
          end
        end

        context "when player already has a roster" do
          context "in a different level" do
            before do
              Fabricate(:roster, team: team, level: 1, position: 1,
                                 player: player)
            end

            context "when valid params" do
              it "destroys old Roster and creates a new Roster" do
                expect do
                  post :create, xhr: true,
                                params: { team_id: team.to_param,
                                          roster: valid_attributes }
                end.not_to change(Roster, :count)
              end

              it "redirects to the Roster list" do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: valid_attributes }
                expect(response).to redirect_to(team_rosters_url(team))
              end
            end

            context "when invalid params" do
              it "doesn't create a new Roster" do
                expect do
                  post :create, xhr: true,
                                params: { team_id: team.to_param,
                                          roster: invalid_attributes }
                end.not_to change(Roster, :count)
              end

              it "renders new" do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: invalid_attributes }
                expect(response).to be_successful
              end
            end
          end

          context "for the current position" do
            let(:other_player) { Fabricate(:pitcher) }
            let!(:current_roster) do
              Fabricate(:roster, team: team, player: player,
                                 level: valid_attributes[:level],
                                 position: valid_attributes[:position])
            end

            before do
              Fabricate(:roster, team: team, level: 2, position: 1,
                                 player: other_player,
                                 row_order_position: :last)
            end

            it "doesn't destroy old Roster" do
              expect do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: valid_attributes }
              end.not_to change(Roster, :count)
            end

            it "updates current Roster's order" do
              expect do
                post :create, xhr: true,
                              params: { team_id: team.to_param,
                                        roster: valid_attributes }
                current_roster.reload
              end.to change(current_roster, :row_order)
            end

            it "renders new" do
              post :create, xhr: true,
                            params: { team_id: team.to_param,
                                      roster: valid_attributes }
              expect(response).to be_successful
            end
          end
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
    before { roster }

    context "for an admin" do
      before { sign_in(admin) }

      context "for an HTML request" do
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

        context "when level doesn't change from 4" do
          let(:player) { Fabricate(:player, primary_position: 3) }
          let(:roster) do
            Fabricate(:roster, team: team, player: player, level: 4,
                               position: player.primary_position)
          end
          let(:update_attributes) { { level: 4 } }
          let(:lineup) { Fabricate(:lineup, team: team) }

          before do
            Fabricate(:spot, lineup: lineup, player: player,
                             position: player.primary_position)
          end

          it "doesn't destroy any spots" do
            expect do
              put :update, params: { team_id: team.to_param,
                                     id: roster.to_param,
                                     roster: update_attributes }
            end.not_to change(Spot, :count)
          end
        end

        context "when level changes from 4" do
          let(:player) { Fabricate(:player, primary_position: 3) }
          let(:roster) do
            Fabricate(:roster, team: team, player: player, level: 4,
                               position: player.primary_position)
          end
          let(:update_attributes) { { level: 3 } }
          let(:lineup) { Fabricate(:lineup, team: team) }

          before do
            Fabricate(:spot, lineup: lineup, player: player,
                             position: player.primary_position)
          end

          it "destroys player's lineup spots" do
            expect do
              put :update, params: { team_id: team.to_param,
                                     id: roster.to_param,
                                     roster: update_attributes }
            end.to change(Spot, :count).by(-1)
          end
        end
      end

      context "for a JS request" do
        context "when params are different level" do
          let(:js_attributes) do
            { player_id: roster.player.id, level: "2",
              position: roster.position }
          end

          it "updates the requested Roster" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
              roster.reload
            end.to change(roster, :level)
          end

          it "renders show" do
            put :update, xhr: true, params: { team_id: team.to_param,
                                              id: roster.to_param,
                                              roster: js_attributes }
            expect(response).to be_successful
          end
        end

        context "when params are same player, level, position" do
          let(:js_attributes) do
            { player_id: roster.player.id, level: roster.level,
              position: roster.position }
          end

          it "doesn't update the requested Roster" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
              roster.reload
            end.not_to change(roster, :updated_at)
          end

          it "renders edit" do
            put :update, xhr: true, params: { team_id: team.to_param,
                                              id: roster.to_param,
                                              roster: js_attributes }
            expect(response).to be_successful
          end
        end

        context "when params are player without a roster" do
          let(:other_player) { Fabricate(:pitcher) }
          let(:js_attributes) do
            { player_id: other_player.id, level: roster.level,
              position: roster.position }
          end

          before { Fabricate(:contract, team: team, player: other_player) }

          it "updates the requested Roster's order" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
              roster.reload
            end.to change(roster, :row_order_rank)
          end

          it "doesn't change the requested Rosters player" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
              roster.reload
            end.not_to change(roster, :player_id)
          end

          it "creates a new Roster" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
            end.to change(Roster, :count).by(1)
          end

          it "creates a Roster for the other player" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
              other_player.reload
            end.to change(other_player, :roster).from(nil)
          end

          it "renders show" do
            put :update, xhr: true, params: { team_id: team.to_param,
                                              id: roster.to_param,
                                              roster: js_attributes }
            expect(response).to be_successful
          end
        end

        context "when new player has roster at that position" do
          let(:other_player) { Fabricate(:pitcher) }
          let(:js_attributes) do
            { player_id: other_player.id, level: roster.level,
              position: roster.position }
          end

          let!(:other_roster) do
            Fabricate(:roster, team: team, player: other_player,
                               level: roster.level, position: roster.position)
          end

          it "updates the requested Roster's order" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
              roster.reload
            end.to change(roster, :row_order_rank)
          end

          it "updates the other Roster's order" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
              other_roster.reload
            end.to change(other_roster, :row_order_rank)
          end

          it "doesn't create a new Roster" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: js_attributes }
            end.not_to change(Roster, :count)
          end

          it "renders show" do
            put :update, xhr: true, params: { team_id: team.to_param,
                                              id: roster.to_param,
                                              roster: js_attributes }
            expect(response).to be_successful
          end
        end

        context "when invalid params" do
          it "doesn't create a new Roster" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: invalid_attributes }
              roster.reload
            end.not_to change(roster, :level)
          end

          it "renders edit" do
            put :update, xhr: true, params: { team_id: team.to_param,
                                              id: roster.to_param,
                                              roster: invalid_attributes }
            expect(response).to be_successful
          end
        end

        context "when level changes from 4" do
          let(:player) { Fabricate(:player, primary_position: 3) }
          let(:roster) do
            Fabricate(:roster, team: team, player: player, level: 4,
                               position: player.primary_position)
          end
          let(:update_attributes) { { level: 3 } }
          let(:lineup) { Fabricate(:lineup, team: team) }

          before do
            Fabricate(:spot, lineup: lineup, player: player,
                             position: player.primary_position)
          end

          it "destroys player's lineup spots" do
            expect do
              put :update, xhr: true, params: { team_id: team.to_param,
                                                id: roster.to_param,
                                                roster: update_attributes }
            end.to change(Spot, :count).by(-1)
          end
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
