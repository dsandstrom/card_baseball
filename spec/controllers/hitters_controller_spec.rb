# frozen_string_literal: true

require "rails_helper"

RSpec.describe HittersController, type: :controller do
  let(:hitter) { Fabricate(:hitter) }

  let(:valid_attributes) do
    { last_name: "Last", primary_position: 4, bats: "R", bunt_grade: "A",
      speed: 2, durability: 64, overall_rating: 75, left_rating: 68,
      right_rating: 84, left_on_base_percentage: 56, left_slugging: 45,
      left_homeruns: 11, right_on_base_percentage: 79, right_slugging: 55,
      right_homeruns: 88 }
  end

  let(:invalid_attributes) { { last_name: "" } }

  describe "GET #index" do
    before { Fabricate(:hitter) }

    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: hitter.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: hitter.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "when valid params" do
      it "creates a new Hitter" do
        expect do
          post :create, params: { hitter: valid_attributes }
        end.to change(Hitter, :count).by(1)
      end

      it "redirects to the Hitter list" do
        post :create, params: { hitter: valid_attributes }
        expect(response).to redirect_to(Hitter.last)
      end
    end

    context "when invalid params" do
      it "doesn't create a new Hitter" do
        expect do
          post :create, params: { hitter: invalid_attributes }
        end.not_to change(Hitter, :count)
      end

      it "renders new" do
        post :create, params: { hitter: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "when valid params" do
      it "updates the requested Hitter" do
        expect do
          put :update, params: { id: hitter.to_param,
                                 hitter: valid_attributes }
          hitter.reload
        end.to change(hitter, :last_name)
      end

      it "redirects to the Hitter" do
        put :update, params: { id: hitter.to_param,
                               hitter: valid_attributes }
        expect(response).to redirect_to(hitter)
      end
    end

    context "when invalid params" do
      it "doesn't create a new Hitter" do
        expect do
          put :update, params: { id: hitter.to_param,
                                 hitter: invalid_attributes }
          hitter.reload
        end.not_to change(hitter, :last_name)
      end

      it "renders edit" do
        put :update, params: { id: hitter.to_param,
                               hitter: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    before { hitter }

    it "destroys the requested Hitter" do
      expect do
        delete :destroy, params: { id: hitter.to_param }
      end.to change(Hitter, :count).by(-1)
    end

    it "redirects to the Hitter list" do
      delete :destroy, params: { id: hitter.to_param }
      expect(response).to redirect_to(:hitters)
    end
  end
end
