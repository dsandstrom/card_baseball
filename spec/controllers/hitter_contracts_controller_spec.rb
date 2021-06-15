# frozen_string_literal: true

require "rails_helper"

RSpec.describe HitterContractsController, type: :controller do
  let(:team) { Fabricate(:team) }
  let(:hitter) { Fabricate(:hitter) }

  let(:valid_attributes) { { team_id: team.to_param, length: 2 } }
  let(:invalid_attributes) { { length: -1 } }

  describe "GET #edit" do
    context "when hitter doesn't have a contract" do
      before { Fabricate(:hitter_contract) }

      it "returns a success response" do
        get :edit, params: { hitter_id: hitter.to_param }
        expect(response).to be_successful
      end
    end

    context "when hitter has a contract" do
      before { Fabricate(:hitter_contract, hitter: hitter) }

      it "returns a success response" do
        get :edit, params: { hitter_id: hitter.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "when hitter doesn't have a contract" do
      before { hitter.contract&.destroy }

      context "when valid params" do
        it "creates a new HitterContract" do
          expect do
            put :update, params: { hitter_id: hitter.to_param,
                                   hitter_contract: valid_attributes }
          end.to change(HitterContract, :count).by(1)
        end

        it "redirects to the Hitter" do
          put :update, params: { hitter_id: hitter.to_param,
                                 hitter_contract: valid_attributes }
          expect(response).to redirect_to(hitter)
        end
      end

      context "when invalid params" do
        it "doesn't create a new HitterContract" do
          expect do
            put :update, params: { hitter_id: hitter.to_param,
                                   hitter_contract: invalid_attributes }
          end.not_to change(HitterContract, :count)
        end

        it "renders edit" do
          put :update, params: { hitter_id: hitter.to_param,
                                 hitter_contract: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    context "when hitter has a contract" do
      let!(:hitter_contract) { Fabricate(:hitter_contract, hitter: hitter) }

      context "when valid params" do
        it "updates the requested HitterContract" do
          expect do
            put :update, params: { hitter_id: hitter.to_param,
                                   hitter_contract: valid_attributes }
            hitter_contract.reload
          end.to change(hitter_contract, :team_id)
        end

        it "doesn't create a new HitterContract" do
          expect do
            put :update, params: { hitter_id: hitter.to_param,
                                   hitter_contract: valid_attributes }
          end.not_to change(HitterContract, :count)
        end

        it "redirects to the Hitter" do
          put :update, params: { hitter_id: hitter.to_param,
                                 hitter_contract: valid_attributes }
          expect(response).to redirect_to(hitter_path(hitter))
        end
      end

      context "when invalid params" do
        it "doesn't change the requested HitterContract" do
          expect do
            put :update, params: { hitter_id: hitter.to_param,
                                   hitter_contract: invalid_attributes }
            hitter_contract.reload
          end.not_to change(hitter_contract, :team_id)
        end

        it "renders edit" do
          put :update, params: { hitter_id: hitter.to_param,
                                 hitter_contract: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { team }

    context "when Hitter doesn't have a contract" do
      before { Fabricate(:hitter_contract) }

      it "doesn't destroy any HitterContracts" do
        expect do
          delete :destroy, params: { hitter_id: hitter.to_param }
        end.not_to change(HitterContract, :count)
      end

      it "redirects to the Hitter" do
        delete :destroy, params: { hitter_id: hitter.to_param }
        expect(response).to redirect_to(hitter)
      end
    end

    context "when Hitter has a contract" do
      let!(:hitter_contract) { Fabricate(:hitter_contract, hitter: hitter) }

      it "destroys the requested HitterContract" do
        expect do
          delete :destroy, params: { hitter_id: hitter.to_param }
        end.to change(HitterContract, :count).by(-1)
      end

      it "redirects to the Hitter" do
        delete :destroy, params: { hitter_id: hitter.to_param }
        expect(response).to redirect_to(hitter)
      end
    end
  end
end
