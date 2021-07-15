# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContractsController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:player) { Fabricate(:player) }
  let(:user) { Fabricate(:user) }

  let(:valid_attributes) { { team_id: team.to_param, length: 2 } }
  let(:invalid_attributes) { { length: -1 } }

  describe "GET #edit" do
    context "for a user" do
      before { sign_in(user) }

      context "when player doesn't have a contract" do
        before { Fabricate(:contract) }

        it "returns a success response" do
          get :edit, params: { player_id: player.to_param }
          expect(response).to be_successful
        end
      end

      context "when player has a contract" do
        before { Fabricate(:contract, player: player) }

        it "returns a success response" do
          get :edit, params: { player_id: player.to_param }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "PUT #update" do
    context "for a user" do
      before { sign_in(user) }

      context "when player doesn't have a contract" do
        before { player.contract&.destroy }

        context "when valid params" do
          it "creates a new Contract" do
            expect do
              put :update, params: { player_id: player.to_param,
                                     contract: valid_attributes }
            end.to change(Contract, :count).by(1)
          end

          it "redirects to the player" do
            put :update, params: { player_id: player.to_param,
                                   contract: valid_attributes }
            expect(response).to redirect_to(player)
          end
        end

        context "when invalid params" do
          it "doesn't create a new Contract" do
            expect do
              put :update, params: { player_id: player.to_param,
                                     contract: invalid_attributes }
            end.not_to change(Contract, :count)
          end

          it "renders edit" do
            put :update, params: { player_id: player.to_param,
                                   contract: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "when player has a contract" do
        let!(:contract) { Fabricate(:contract, player: player) }

        context "when valid params" do
          it "updates the requested Contract" do
            expect do
              put :update, params: { player_id: player.to_param,
                                     contract: valid_attributes }
              contract.reload
            end.to change(contract, :team_id)
          end

          it "doesn't create a new Contract" do
            expect do
              put :update, params: { player_id: player.to_param,
                                     contract: valid_attributes }
            end.not_to change(Contract, :count)
          end

          it "redirects to the player" do
            put :update, params: { player_id: player.to_param,
                                   contract: valid_attributes }
            expect(response).to redirect_to(player_path(player))
          end
        end

        context "when invalid params" do
          it "doesn't change the requested Contract" do
            expect do
              put :update, params: { player_id: player.to_param,
                                     contract: invalid_attributes }
              contract.reload
            end.not_to change(contract, :team_id)
          end

          it "renders edit" do
            put :update, params: { player_id: player.to_param,
                                   contract: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { team }

    context "for a user" do
      before { sign_in(user) }

      context "when player doesn't have a contract" do
        before { Fabricate(:contract) }

        it "doesn't destroy any Contracts" do
          expect do
            delete :destroy, params: { player_id: player.to_param }
          end.not_to change(Contract, :count)
        end

        it "redirects to the player" do
          delete :destroy, params: { player_id: player.to_param }
          expect(response).to redirect_to(player)
        end
      end

      context "when player has a contract" do
        let!(:contract) { Fabricate(:contract, player: player) }

        it "destroys the requested Contract" do
          expect do
            delete :destroy, params: { player_id: player.to_param }
          end.to change(Contract, :count).by(-1)
        end

        it "redirects to the player" do
          delete :destroy, params: { player_id: player.to_param }
          expect(response).to redirect_to(player)
        end
      end
    end
  end
end
