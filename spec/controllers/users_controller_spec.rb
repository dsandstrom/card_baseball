# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }
  let(:another_user) { Fabricate(:user) }
  let(:another_admin) { Fabricate(:admin) }

  let(:valid_attributes) do
    { name: "Name", email: "user@example.org",
      password: "testpass", password_confirmation: "testpass" }
  end
  let(:invalid_attributes) { { name: "" } }
  let(:update_attributes) { { name: "New Name" } }

  describe "GET #new" do
    context "for a guest" do
      it "redirects to sign_in" do
        get :new
        expect(response).to redirect_to(:new_user_session)
      end
    end

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

      context "when a user" do
        it "returns a success response" do
          get :edit, params: { id: user.to_param }
          expect(response).to be_successful
        end
      end

      context "when another admin" do
        it "returns a success response" do
          get :edit, params: { id: another_admin.to_param }
          expect(response).to be_successful
        end
      end

      context "when themselves" do
        it "returns a success response" do
          get :edit, params: { id: admin.to_param }
          expect(response).to be_successful
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      context "when an admin" do
        it "redirects to unauthorized" do
          get :edit, params: { id: admin.to_param }
          expect_to_be_unauthorized(response)
        end
      end

      context "when another user" do
        it "redirects to unauthorized" do
          get :edit, params: { id: another_user.to_param }
          expect_to_be_unauthorized(response)
        end
      end

      context "when themselves" do
        it "returns a success response" do
          get :edit, params: { id: user.to_param }
          expect(response).to be_successful
        end
      end
    end
  end

  describe "POST #create" do
    context "for an admin" do
      before { sign_in(admin) }

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

    context "for a user" do
      before { sign_in(user) }

      it "doesn't create a new User" do
        expect do
          post :create, params: { user: valid_attributes }
        end.not_to change(User, :count)
      end

      it "redirects to unauthorized" do
        post :create, params: { user: valid_attributes }
        expect_to_be_unauthorized(response)
      end
    end
  end

  describe "PUT #update" do
    before { user }

    context "for an admin" do
      let(:current_user) { Fabricate(:admin) }

      before { sign_in(current_user) }

      context "when a user" do
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

      context "when another admin" do
        context "when valid params" do
          it "updates the requested User" do
            expect do
              put :update, params: { id: another_admin.to_param,
                                     user: update_attributes }
              another_admin.reload
            end.to change(another_admin, :name)
          end

          it "redirects to the User" do
            put :update, params: { id: another_admin.to_param,
                                   user: update_attributes }
            expect(response).to redirect_to(another_admin)
          end
        end

        context "when invalid params" do
          it "doesn't change the requested User's name" do
            expect do
              put :update, params: { id: another_admin.to_param,
                                     user: invalid_attributes }
              another_admin.reload
            end.not_to change(another_admin, :name)
          end

          it "renders edit" do
            put :update, params: { id: another_admin.to_param,
                                   user: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end

      context "when themselves" do
        context "when valid params" do
          it "updates the requested User" do
            expect do
              put :update, params: { id: current_user.to_param,
                                     user: update_attributes }
              current_user.reload
            end.to change(current_user, :name)
          end

          it "redirects to the User" do
            put :update, params: { id: current_user.to_param,
                                   user: update_attributes }
            expect(response).to redirect_to(current_user)
          end
        end

        context "when invalid params" do
          it "doesn't change the requested User's name" do
            expect do
              put :update, params: { id: current_user.to_param,
                                     user: invalid_attributes }
              current_user.reload
            end.not_to change(current_user, :name)
          end

          it "renders edit" do
            put :update, params: { id: current_user.to_param,
                                   user: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end
    end

    context "for a user" do
      let(:current_user) { Fabricate(:user) }

      before { sign_in(current_user) }

      context "when another user" do
        it "doesn't update the requested User" do
          expect do
            put :update, params: { id: another_user.to_param,
                                   user: update_attributes }
            another_user.reload
          end.not_to change(another_user, :name)
        end

        it "redirects to unauthorized" do
          put :update, params: { id: another_user.to_param,
                                 user: update_attributes }
          expect_to_be_unauthorized(response)
        end
      end

      context "when an admin" do
        it "doesn't update the requested User" do
          expect do
            put :update, params: { id: admin.to_param,
                                   user: update_attributes }
            admin.reload
          end.not_to change(admin, :name)
        end

        it "redirects to unauthorized" do
          put :update, params: { id: admin.to_param,
                                 user: update_attributes }
          expect_to_be_unauthorized(response)
        end
      end

      context "when themselves" do
        context "when valid params" do
          it "updates the requested User" do
            expect do
              put :update, params: { id: current_user.to_param,
                                     user: update_attributes }
              current_user.reload
            end.to change(current_user, :name)
          end

          it "redirects to the User" do
            put :update, params: { id: current_user.to_param,
                                   user: update_attributes }
            expect(response).to redirect_to(current_user)
          end
        end

        context "when invalid params" do
          it "doesn't change the requested User's name" do
            expect do
              put :update, params: { id: current_user.to_param,
                                     user: invalid_attributes }
              current_user.reload
            end.not_to change(current_user, :name)
          end

          it "renders edit" do
            put :update, params: { id: current_user.to_param,
                                   user: invalid_attributes }
            expect(response).to be_successful
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before { user }

    context "for an admin" do
      let(:current_user) { Fabricate(:admin) }

      before { sign_in(current_user) }

      context "when a user" do
        before { user }

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

      context "when another admin" do
        before { another_admin }

        it "destroys the requested User" do
          expect do
            delete :destroy, params: { id: another_admin.to_param }
          end.to change(User, :count).by(-1)
        end

        it "redirects to the User list" do
          delete :destroy, params: { id: another_admin.to_param }
          expect(response).to redirect_to(:users)
        end
      end

      context "when themselves" do
        it "doesn't destroy the requested User" do
          expect do
            delete :destroy, params: { id: current_user.to_param }
          end.not_to change(User, :count)
        end

        it "redirects to unauthorized" do
          delete :destroy, params: { id: current_user.to_param }
          expect_to_be_unauthorized(response)
        end
      end
    end

    context "for a user" do
      let(:current_user) { Fabricate(:user) }

      before { sign_in(current_user) }

      context "when an admin" do
        before { admin }

        it "doesn't destroy the requested User" do
          expect do
            delete :destroy, params: { id: admin.to_param }
          end.not_to change(User, :count)
        end

        it "redirects to unauthorized" do
          delete :destroy, params: { id: admin.to_param }
          expect_to_be_unauthorized(response)
        end
      end

      context "when another user" do
        before { another_user }

        it "doesn't destroy the requested User" do
          expect do
            delete :destroy, params: { id: another_user.to_param }
          end.not_to change(User, :count)
        end

        it "redirects to unauthorized" do
          delete :destroy, params: { id: another_user.to_param }
          expect_to_be_unauthorized(response)
        end
      end

      context "when themselves" do
        it "doesn't destroy the requested User" do
          expect do
            delete :destroy, params: { id: current_user.to_param }
          end.not_to change(User, :count)
        end

        it "redirects to unauthorized" do
          delete :destroy, params: { id: current_user.to_param }
          expect_to_be_unauthorized(response)
        end
      end
    end
  end
end
