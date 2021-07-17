# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlayersController, type: :controller do
  let(:player) { Fabricate(:player) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  let(:valid_attributes) do
    { last_name: "Last", primary_position: 4, bats: "R", bunt_grade: "A",
      speed: 2, offensive_durability: 64, offensive_rating: 75,
      left_hitting: 68, right_hitting: 84, left_on_base_percentage: 56,
      left_slugging: 45, left_homerun: 11, right_on_base_percentage: 79,
      right_slugging: 55, right_homerun: 88 }
  end

  let(:invalid_attributes) { { last_name: "" } }

  describe "GET #index" do
    context "for an admin" do
      before { sign_in(admin) }

      before { Fabricate(:player) }

      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      before { Fabricate(:player) }

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
        get :show, params: { id: player.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :show, params: { id: player.to_param }
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
        get :edit, params: { id: player.to_param }
        expect(response).to be_successful
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :edit, params: { id: player.to_param }
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "POST #create" do
    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params" do
        it "creates a new Player" do
          expect do
            post :create, params: { player: valid_attributes }
          end.to change(Player, :count).by(1)
        end

        it "redirects to the Player list" do
          post :create, params: { player: valid_attributes }
          expect(response).to redirect_to(Player.last)
        end
      end

      context "when invalid params" do
        it "doesn't create a new Player" do
          expect do
            post :create, params: { player: invalid_attributes }
          end.not_to change(Player, :count)
        end

        it "renders new" do
          post :create, params: { player: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "doesn't create a new Player" do
        expect do
          post :create, params: { player: valid_attributes }
        end.not_to change(Player, :count)
      end

      it "redirects to unauthorized" do
        post :create, params: { player: valid_attributes }
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "PUT #update" do
    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params" do
        it "updates the requested Player" do
          expect do
            put :update, params: { id: player.to_param,
                                   player: valid_attributes }
            player.reload
          end.to change(player, :last_name)
        end

        it "redirects to the Player" do
          put :update, params: { id: player.to_param,
                                 player: valid_attributes }
          expect(response).to redirect_to(player)
        end
      end

      context "when invalid params" do
        it "doesn't create a new Player" do
          expect do
            put :update, params: { id: player.to_param,
                                   player: invalid_attributes }
            player.reload
          end.not_to change(player, :last_name)
        end

        it "renders edit" do
          put :update, params: { id: player.to_param,
                                 player: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "doesn't create a new Player" do
        expect do
          put :update, params: { id: player.to_param,
                                 player: valid_attributes }
          player.reload
        end.not_to change(player, :last_name)
      end

      it "redirects to unauthorizedd" do
        put :update, params: { id: player.to_param,
                               player: valid_attributes }
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "DELETE #destroy" do
    context "for an admin" do
      before { sign_in(admin) }

      before { player }

      it "destroys the requested Player" do
        expect do
          delete :destroy, params: { id: player.to_param }
        end.to change(Player, :count).by(-1)
      end

      it "redirects to the Player list" do
        delete :destroy, params: { id: player.to_param }
        expect(response).to redirect_to(:players)
      end
    end

    context "for a user" do
      before { sign_in(user) }

      before { player }

      it "doesn't destroy the requested Player" do
        expect do
          delete :destroy, params: { id: player.to_param }
        end.not_to change(Player, :count)
      end

      it "redirects to unauthorized" do
        delete :destroy, params: { id: player.to_param }
        expect_to_be_unauthorized(response)
      end
    end
  end
end
