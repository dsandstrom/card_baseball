# frozen_string_literal: true

require "rails_helper"

RSpec.describe SortLeaguesController, type: :controller do
  let(:league) { Fabricate(:league) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  let(:valid_attributes) { { row_order_position: "up" } }
  let(:invalid_attributes) { { row_order_position: "nope" } }

  before { Fabricate(:league) }

  describe "PUT #update" do
    context "for an admin" do
      before { sign_in(admin) }

      context "when valid params" do
        it "updates the requested League" do
          expect do
            put :update, params: { id: league.to_param,
                                   league: valid_attributes }
            league.reload
          end.to change(league, :row_order)
        end

        it "redirects to the League" do
          put :update, params: { id: league.to_param,
                                 league: valid_attributes }
          expect(response).to redirect_to(leagues_url)
        end
      end

      context "when invalid params" do
        it "doesn't change the requested League" do
          expect do
            put :update, params: { id: league.to_param,
                                   league: invalid_attributes }
            league.reload
          end.not_to change(league, :row_order)
        end

        it "renders edit" do
          put :update, params: { id: league.to_param,
                                 league: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    context "for a user" do
      before { sign_in(user) }

      it "doesn't create a new League" do
        expect do
          put :update, params: { id: league.to_param,
                                 league: valid_attributes }
          league.reload
        end.not_to change(league, :row_order)
      end

      it "redirects to unauthorized" do
        put :update, params: { id: league.to_param,
                               league: valid_attributes }
        expect_to_be_unauthorized(response)
      end
    end
  end
end
