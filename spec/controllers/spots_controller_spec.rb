# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpotsController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:hitter) do
    Fabricate(:hitter, primary_position: 2, defense2: 5, defense3: 1)
  end
  let(:lineup) { Fabricate(:lineup, team: team) }
  let(:spot) do
    Fabricate(:spot, lineup: lineup, hitter: hitter, batting_order: 4,
                     position: 2)
  end

  before do
    Fabricate(:contract, player: hitter, team: team)
    Fabricate(:roster, player: hitter, team: team, level: 4, position: 2)
  end

  let(:valid_attributes) do
    { hitter_id: hitter.to_param, position: 2, batting_order: 2 }
  end

  let(:update_attributes) { { position: 3 } }
  let(:invalid_attributes) { { position: "" } }

  describe "GET #new" do
    context "for an admin" do
      before { sign_in(admin) }

      context "for an HTML request" do
        it "returns a success response" do
          get :new, params: { lineup_id: lineup.to_param }
          expect(response).to be_successful
        end
      end

      context "for a JS request" do
        it "returns a success response" do
          get :new, params: { lineup_id: lineup.to_param }, xhr: true
          expect(response).to be_successful
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
          it "returns a success response" do
            get :new, params: { lineup_id: lineup.to_param }
            expect(response).to be_successful
          end
        end

        context "for a JS request" do
          it "returns a success response" do
            get :new, params: { lineup_id: lineup.to_param }, xhr: true
            expect(response).to be_successful
          end
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
          it "returns a success response" do
            get :new, params: { lineup_id: lineup.to_param }
            expect_to_be_unauthorized(response)
          end
        end

        context "for a JS request" do
          it "returns a success response" do
            get :new, params: { lineup_id: lineup.to_param }, xhr: true
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe "GET #edit" do
    context "for an admin" do
      before do
        spot
        sign_in(admin)
      end

      context "for an HTML request" do
        it "returns a success response" do
          get :edit, params: { lineup_id: lineup.to_param, id: spot.to_param }
          expect(response).to be_successful
        end
      end

      context "for a JS request" do
        it "returns a success response" do
          get :edit, params: { lineup_id: lineup.to_param, id: spot.to_param },
                     xhr: true
          expect(response).to be_successful
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        before { spot }

        context "for an HTML request" do
          it "returns a success response" do
            get :edit, params: { lineup_id: lineup.to_param,
                                 id: spot.to_param }
            expect(response).to be_successful
          end
        end

        context "for a JS request" do
          it "returns a success response" do
            get :edit, params: { lineup_id: lineup.to_param,
                                 id: spot.to_param },
                       xhr: true
            expect(response).to be_successful
          end
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        before { spot }

        context "for an HTML request" do
          it "returns a success response" do
            get :edit, params: { lineup_id: lineup.to_param,
                                 id: spot.to_param }
            expect_to_be_unauthorized(response)
          end
        end

        context "for a JS request" do
          it "returns a success response" do
            get :edit, params: { lineup_id: lineup.to_param,
                                 id: spot.to_param },
                       xhr: true
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe "POST #create" do
    context "for an admin" do
      before { sign_in(admin) }

      context "for an HTML request" do
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

      context "for a JS request" do
        context "when valid params" do
          it "creates a new Spot" do
            expect do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes },
                            xhr: true
            end.to change(Spot, :count).by(1)
          end

          it "redirects to the Spot list" do
            post :create, params: { lineup_id: lineup.to_param,
                                    spot: valid_attributes },
                          xhr: true
            expect(response).to be_successful
          end
        end

        context "when invalid params" do
          it "doesn't create a new Spot" do
            expect do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: invalid_attributes },
                            xhr: true
            end.not_to change(Spot, :count)
          end

          it "renders new" do
            post :create, params: { lineup_id: lineup.to_param,
                                    spot: invalid_attributes },
                          xhr: true
            expect(response).to be_successful
          end
        end

        context "when hitter has a current spot in the lineup" do
          before do
            Fabricate(:spot, lineup: lineup, hitter: hitter, batting_order: 1,
                             position: 2)
          end

          let(:valid_attributes) do
            { hitter_id: hitter.to_param, batting_order: 2 }
          end

          it "doesn't change the overall Spot's count" do
            expect do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes },
                            xhr: true
            end.not_to change(Spot, :count)
          end

          it "destroys the old spot" do
            old_spot = lineup.spots.find_by(hitter_id: hitter.id)
            expect(old_spot).not_to be_nil
            old_spot_id = old_spot.id

            post :create, params: { lineup_id: lineup.to_param,
                                    spot: valid_attributes },
                          xhr: true
            expect(Spot.find_by(id: old_spot_id)).to be_nil
          end

          it "creates a new spot" do
            post :create, params: { lineup_id: lineup.to_param,
                                    spot: valid_attributes },
                          xhr: true
            new_spot = Spot.last
            expect(new_spot).not_to be_nil
            expect(new_spot.hitter_id).to eq(hitter.id)
            expect(new_spot.batting_order).to eq(2)
            expect(new_spot.position).to eq(2)
          end

          it "renders show" do
            post :create, params: { lineup_id: lineup.to_param,
                                    spot: valid_attributes },
                          xhr: true
            expect(response).to be_successful
          end
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
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

        context "for a JS request" do
          context "when valid params" do
            it "creates a new Spot" do
              expect do
                post :create, params: { lineup_id: lineup.to_param,
                                        spot: valid_attributes },
                              xhr: true
              end.to change(Spot, :count).by(1)
            end

            it "redirects to the Spot list" do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes },
                            xhr: true
              expect(response).to be_successful
            end
          end

          context "when invalid params" do
            it "doesn't create a new Spot" do
              expect do
                post :create, params: { lineup_id: lineup.to_param,
                                        spot: invalid_attributes },
                              xhr: true
              end.not_to change(Spot, :count)
            end

            it "renders new" do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: invalid_attributes },
                            xhr: true
              expect(response).to be_successful
            end
          end

          context "when hitter has a current spot in the lineup" do
            before do
              Fabricate(:spot, lineup: lineup, hitter: hitter, batting_order: 1,
                               position: 2)
            end

            let(:valid_attributes) do
              { hitter_id: hitter.to_param, batting_order: 2 }
            end

            it "doesn't change the overall Spot's count" do
              expect do
                post :create, params: { lineup_id: lineup.to_param,
                                        spot: valid_attributes },
                              xhr: true
              end.not_to change(Spot, :count)
            end

            it "destroys the old spot" do
              old_spot = lineup.spots.find_by(hitter_id: hitter.id)
              expect(old_spot).not_to be_nil
              old_spot_id = old_spot.id

              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes },
                            xhr: true
              expect(Spot.find_by(id: old_spot_id)).to be_nil
            end

            it "creates a new spot" do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes },
                            xhr: true
              new_spot = Spot.last
              expect(new_spot).not_to be_nil
              expect(new_spot.hitter_id).to eq(hitter.id)
              expect(new_spot.batting_order).to eq(2)
              expect(new_spot.position).to eq(2)
            end

            it "renders show" do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes },
                            xhr: true
              expect(response).to be_successful
            end
          end
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
          it "doesn't create a new Spot" do
            expect do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes }
            end.not_to change(Spot, :count)
          end

          it "renders new" do
            post :create, params: { lineup_id: lineup.to_param,
                                    spot: valid_attributes }
            expect_to_be_unauthorized(response)
          end
        end

        context "for a JS request" do
          it "doesn't create a new Spot" do
            expect do
              post :create, params: { lineup_id: lineup.to_param,
                                      spot: valid_attributes },
                            xhr: true
            end.not_to change(Spot, :count)
          end

          it "renders new" do
            post :create, params: { lineup_id: lineup.to_param,
                                    spot: valid_attributes },
                          xhr: true
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe "PUT #update" do
    before { spot }

    context "for an admin" do
      before { sign_in(admin) }

      context "for an HTML request" do
        context "when valid params" do
          it "updates the requested Spot" do
            expect do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: update_attributes }
              spot.reload
            end.to change(spot, :position)
          end

          it "redirects to the Spot" do
            put :update, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param,
                                   spot: update_attributes }
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
            end.not_to change(spot, :position)
          end

          it "renders edit" do
            put :update, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param,
                                   spot: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "for a JS request" do
        context "when valid params" do
          it "updates the requested Spot" do
            expect do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: update_attributes },
                           xhr: true
              spot.reload
            end.to change(spot, :position)
          end

          it "redirects to the Spot" do
            put :update, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param,
                                   spot: update_attributes },
                         xhr: true
            expect(response).to be_successful
          end
        end

        context "when the same params" do
          let(:update_attributes) do
            { hitter_id: spot.hitter_id, position: spot.position }
          end

          it "updates the requested Spot" do
            expect do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: update_attributes },
                           xhr: true
              spot.reload
            end.not_to change(spot, :hitter_id)
          end

          it "redirects to the Spot" do
            put :update, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param,
                                   spot: update_attributes },
                         xhr: true
            expect(response).to be_successful
          end
        end

        context "when invalid params" do
          it "doesn't change the requested Spot's name" do
            expect do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: invalid_attributes },
                           xhr: true
              spot.reload
            end.not_to change(spot, :position)
          end

          it "renders edit" do
            put :update, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param,
                                   spot: invalid_attributes },
                         xhr: true
            expect(response).to be_successful
          end
        end

        context "when switching hitters" do
          context "from the bench" do
            context "when hitter plays spot's position" do
              let(:bench_hitter) do
                Fabricate(:hitter, primary_position: 2, defense2: -1)
              end
              let(:update_attributes) { { hitter_id: bench_hitter.to_param } }

              before do
                Fabricate(:contract, player: bench_hitter, team: team)
                Fabricate(:roster, player: bench_hitter, team: team, level: 4,
                                   position: 2)
              end

              it "updates the requested Spot" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                  spot.reload
                end.to change(spot, :hitter_id).to(bench_hitter.id)
              end

              it "doesn't change overall Spot count" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                end.not_to change(Spot, :count)
              end

              it "redirects to the Spot" do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                expect(response).to be_successful
              end
            end

            context "when hitter doesn't play spot's position" do
              let(:bench_hitter) do
                Fabricate(:hitter, primary_position: 3, defense3: 9)
              end
              let(:update_attributes) { { hitter_id: bench_hitter.to_param } }

              before do
                Fabricate(:contract, player: bench_hitter, team: team)
              end

              it "updates the requested Spot" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                  spot.reload
                end.not_to change(spot, :hitter_id)
              end

              it "renders edit" do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                expect(response).to be_successful
              end
            end
          end

          context "from another spot in the requested lineup" do
            let(:new_hitter) do
              Fabricate(:hitter, primary_position: 2, defense2: 10, defense3: 0)
            end

            before do
              Fabricate(:contract, player: new_hitter, team: team)
              Fabricate(:roster, player: new_hitter, team: team, level: 4,
                                 position: 2)
            end

            let!(:old_spot) do
              Fabricate(:spot, lineup: lineup, hitter: new_hitter, position: 3,
                               batting_order: 7)
            end

            let(:update_attributes) { { hitter_id: new_hitter.to_param } }

            it "updates the requested Spot's hitter" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                spot.reload
              end.to change(spot, :hitter_id).to(new_hitter.id)
            end

            it "updates the requested Spot's position" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                spot.reload
              end.to change(spot, :position).to(3)
            end

            it "updates the old Spot's hitter" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                old_spot.reload
              end.to change(old_spot, :hitter_id).to(hitter.id)
            end

            it "updates the old Spot's position" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                old_spot.reload
              end.to change(old_spot, :position).to(2)
            end

            it "doesn't change overall Spot count" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
              end.not_to change(Spot, :count)
            end

            it "redirects to the Spot" do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: update_attributes },
                           xhr: true
              expect(response).to be_successful
            end
          end
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
          context "when valid params" do
            it "updates the requested Spot" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes }
                spot.reload
              end.to change(spot, :position)
            end

            it "redirects to the Spot" do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: update_attributes }
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
              end.not_to change(spot, :position)
            end

            it "renders edit" do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: invalid_attributes }
              expect(response).to be_successful
            end
          end
        end

        context "for a JS request" do
          context "when valid params" do
            it "updates the requested Spot" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                spot.reload
              end.to change(spot, :position)
            end

            it "redirects to the Spot" do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: update_attributes },
                           xhr: true
              expect(response).to be_successful
            end
          end

          context "when the same params" do
            let(:update_attributes) do
              { hitter_id: spot.hitter_id, position: spot.position }
            end

            it "updates the requested Spot" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                spot.reload
              end.not_to change(spot, :hitter_id)
            end

            it "redirects to the Spot" do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: update_attributes },
                           xhr: true
              expect(response).to be_successful
            end
          end

          context "when invalid params" do
            it "doesn't change the requested Spot's name" do
              expect do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: invalid_attributes },
                             xhr: true
                spot.reload
              end.not_to change(spot, :position)
            end

            it "renders edit" do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: invalid_attributes },
                           xhr: true
              expect(response).to be_successful
            end
          end

          context "when switching hitters" do
            context "from the bench" do
              context "when hitter plays spot's position" do
                let(:bench_hitter) do
                  Fabricate(:hitter, primary_position: 2, defense2: -1)
                end
                let(:update_attributes) { { hitter_id: bench_hitter.to_param } }

                before do
                  Fabricate(:contract, player: bench_hitter, team: team)
                  Fabricate(:roster, player: bench_hitter, team: team, level: 4,
                                     position: 2)
                end

                it "updates the requested Spot" do
                  expect do
                    put :update, params: { lineup_id: lineup.to_param,
                                           id: spot.to_param,
                                           spot: update_attributes },
                                 xhr: true
                    spot.reload
                  end.to change(spot, :hitter_id).to(bench_hitter.id)
                end

                it "doesn't change overall Spot count" do
                  expect do
                    put :update, params: { lineup_id: lineup.to_param,
                                           id: spot.to_param,
                                           spot: update_attributes },
                                 xhr: true
                  end.not_to change(Spot, :count)
                end

                it "redirects to the Spot" do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                  expect(response).to be_successful
                end
              end
            end

            context "from another spot in the requested lineup" do
              let(:new_hitter) do
                Fabricate(:hitter, primary_position: 2, defense2: 10,
                                   defense3: 0)
              end

              before do
                Fabricate(:contract, player: new_hitter, team: team)
                Fabricate(:roster, player: new_hitter, team: team, level: 4,
                                   position: 2)
              end

              let!(:old_spot) do
                Fabricate(:spot, lineup: lineup, hitter: new_hitter,
                                 position: 3, batting_order: 7)
              end

              let(:update_attributes) { { hitter_id: new_hitter.to_param } }

              it "updates the requested Spot's hitter" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                  spot.reload
                end.to change(spot, :hitter_id).to(new_hitter.id)
              end

              it "updates the requested Spot's position" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                  spot.reload
                end.to change(spot, :position).to(3)
              end

              it "updates the old Spot's hitter" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                  old_spot.reload
                end.to change(old_spot, :hitter_id).to(hitter.id)
              end

              it "updates the old Spot's position" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                  old_spot.reload
                end.to change(old_spot, :position).to(2)
              end

              it "doesn't change overall Spot count" do
                expect do
                  put :update, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param,
                                         spot: update_attributes },
                               xhr: true
                end.not_to change(Spot, :count)
              end

              it "redirects to the Spot" do
                put :update, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param,
                                       spot: update_attributes },
                             xhr: true
                expect(response).to be_successful
              end
            end
          end
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
          it "doesn't change the requested Spot's name" do
            expect do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: valid_attributes }
              spot.reload
            end.not_to change(spot, :position)
          end

          it "renders edit" do
            put :update, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param,
                                   spot: valid_attributes }
            expect_to_be_unauthorized(response)
          end
        end

        context "for a JS request" do
          it "doesn't change the requested Spot's name" do
            expect do
              put :update, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param,
                                     spot: valid_attributes },
                           xhr: true
              spot.reload
            end.not_to change(spot, :position)
          end

          it "renders edit" do
            put :update, params: { lineup_id: lineup.to_param,
                                   id: spot.to_param,
                                   spot: valid_attributes },
                         xhr: true
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { spot }

    context "for an admin" do
      before { sign_in(admin) }

      context "for an HTML request" do
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

      context "for a JS request" do
        it "destroys the requested Spot" do
          expect do
            delete :destroy, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param },
                             xhr: true
          end.to change(Spot, :count).by(-1)
        end

        it "redirects to the Spot list" do
          delete :destroy, params: { lineup_id: lineup.to_param,
                                     id: spot.to_param },
                           xhr: true
          expect(response).to be_successful
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when their team" do
        let(:team) { Fabricate(:team, user_id: user.id) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
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

        context "for a JS request" do
          it "destroys the requested Spot" do
            expect do
              delete :destroy, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param },
                               xhr: true
            end.to change(Spot, :count).by(-1)
          end

          it "redirects to the Spot list" do
            delete :destroy, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param },
                             xhr: true
            expect(response).to be_successful
          end
        end
      end

      context "when not their team" do
        let(:team) { Fabricate(:team) }
        let(:lineup) { Fabricate(:lineup, team: team) }

        context "for an HTML request" do
          it "doesn't destroys the requested Spot" do
            expect do
              delete :destroy, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param }
            end.not_to change(Spot, :count)
          end

          it "redirects to unauthorized" do
            delete :destroy, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param }
            expect_to_be_unauthorized(response)
          end
        end

        context "for a JS request" do
          it "doesn't destroy the requested Spot" do
            expect do
              delete :destroy, params: { lineup_id: lineup.to_param,
                                         id: spot.to_param },
                               xhr: true
            end.not_to change(Spot, :count)
          end

          it "redirects to the Spot list" do
            delete :destroy, params: { lineup_id: lineup.to_param,
                                       id: spot.to_param },
                             xhr: true
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end
end
