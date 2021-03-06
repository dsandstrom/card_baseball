# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeaguesController, type: :controller do
  let(:league) { Fabricate(:league) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  let(:valid_attributes) { { name: "Name" } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET #index" do
    context "for an admin" do
      before { sign_in(admin) }

      before { Fabricate(:league) }

      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      before { Fabricate(:league) }

      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :show, params: { id: league.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :show, params: { id: league.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #new" do
    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "redirects to unauthorized" do
        get :new
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "GET #edit" do
    context "for an admin" do
      before { sign_in(admin) }

      it "returns a success response" do
        get :edit, params: { id: league.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "redirects to unauthorized" do
        get :edit, params: { id: league.to_param }
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "POST #create" do
    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params" do
        it "creates a new League" do
          expect do
            post :create, params: { league: valid_attributes }
          end.to change(League, :count).by(1)
        end

        it "redirects to the League list" do
          post :create, params: { league: valid_attributes }
          expect(response).to redirect_to(:leagues)
        end
      end

      context "when invalid params" do
        it "doesn't create a new League" do
          expect do
            post :create, params: { league: invalid_attributes }
          end.not_to change(League, :count)
        end

        it "renders new" do
          post :create, params: { league: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "doesn't create a new League" do
        expect do
          post :create, params: { league: valid_attributes }
        end.not_to change(League, :count)
      end

      it "redirects to unauthorized" do
        post :create, params: { league: valid_attributes }
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "PUT #update" do
    before { league }

    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params" do
        it "updates the requested League" do
          expect do
            put :update, params: { id: league.to_param,
                                   league: valid_attributes }
            league.reload
          end.to change(league, :name)
        end

        it "redirects to the League" do
          put :update, params: { id: league.to_param,
                                 league: valid_attributes }
          expect(response).to redirect_to(league)
        end
      end

      context "when invalid params" do
        it "doesn't create a new League" do
          expect do
            put :update, params: { id: league.to_param,
                                   league: invalid_attributes }
            league.reload
          end.not_to change(league, :name)
        end

        it "renders edit" do
          put :update, params: { id: league.to_param,
                                 league: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "doesn't create a new League" do
        expect do
          put :update, params: { id: league.to_param,
                                 league: valid_attributes }
        end.not_to change(League, :count)
      end

      it "redirects to unauthorized" do
        put :update, params: { id: league.to_param,
                               league: valid_attributes }
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "DELETE #destroy" do
    before { league }

    context "for an admin" do
      before { sign_in(admin) }

      it "destroys the requested League" do
        expect do
          delete :destroy, params: { id: league.to_param }
        end.to change(League, :count).by(-1)
      end

      it "redirects to the League list" do
        delete :destroy, params: { id: league.to_param }
        expect(response).to redirect_to(:leagues)
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "doesn't destroy the requested League" do
        expect do
          delete :destroy, params: { id: league.to_param }
        end.not_to change(League, :count)
      end

      it "redirects to unauthorized" do
        delete :destroy, params: { id: league.to_param }
        expect_to_be_unauthorized(response)
      end
    end
  end
end
