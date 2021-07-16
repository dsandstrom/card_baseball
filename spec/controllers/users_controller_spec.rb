# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) { Fabricate(:user) }

  let(:valid_attributes) do
    { name: "Name", email: "user@example.org",
      password: "testpass", password_confirmation: "testpass" }
  end
  let(:invalid_attributes) { { name: "" } }
  let(:update_attributes) { { name: "New Name" } }

  describe "GET #new" do
    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe "GET #edit" do
    context "for a user" do
      before { sign_in(user) }

      it "returns a success response" do
        get :edit, params: { id: user.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "POST #create" do
    context "for a user" do
      before { sign_in(user) }

      context "when valid params" do
        it "creates a new User" do
          expect do
            post :create, params: { user: valid_attributes }
          end.to change(User, :count).by(1)
        end

        it "redirects to the User list" do
          post :create, params: { user: valid_attributes }
          expect(response).to redirect_to(:users)
        end
      end

      context "when invalid params" do
        it "doesn't create a new User" do
          expect do
            post :create, params: { user: invalid_attributes }
          end.not_to change(User, :count)
        end

        it "renders new" do
          post :create, params: { user: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "PUT #update" do
    before { user }

    context "for a user" do
      let(:current_user) { Fabricate(:user) }

      before { sign_in(current_user) }

      context "when valid params" do
        it "updates the requested User" do
          expect do
            put :update, params: { id: user.to_param,
                                   user: update_attributes }
            user.reload
          end.to change(user, :name)
        end

        it "redirects to the User" do
          put :update, params: { id: user.to_param,
                                 user: update_attributes }
          expect(response).to redirect_to(user)
        end
      end

      context "when invalid params" do
        it "doesn't change the requested User's name" do
          expect do
            put :update, params: { id: user.to_param,
                                   user: invalid_attributes }
            user.reload
          end.not_to change(user, :name)
        end

        it "renders edit" do
          put :update, params: { id: user.to_param,
                                 user: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { user }

    context "for a user" do
      let(:current_user) { Fabricate(:user) }

      before { sign_in(current_user) }

      it "destroys the requested User" do
        expect do
          delete :destroy, params: { id: user.to_param }
        end.to change(User, :count).by(-1)
      end

      it "redirects to the User list" do
        delete :destroy, params: { id: user.to_param }
        expect(response).to redirect_to(:users)
      end
    end
  end
end
