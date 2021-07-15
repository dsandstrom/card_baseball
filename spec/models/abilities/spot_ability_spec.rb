# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team: team) }
  let(:spot) { Fabricate(:spot, lineup: lineup) }
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "Spot model" do
    context "for a user" do
      context "when not their team" do
        subject(:ability) { Ability.new(user) }

        it { is_expected.not_to be_able_to(:create, spot) }
        it { is_expected.to be_able_to(:read, spot) }
        it { is_expected.not_to be_able_to(:update, spot) }
        it { is_expected.not_to be_able_to(:destroy, spot) }
      end

      context "when their team" do
        let(:team) { Fabricate(:team, user: user) }
        let(:lineup) { Fabricate(:lineup, team: team) }
        let(:spot) { Fabricate(:spot, lineup: lineup) }

        subject(:ability) { Ability.new(user) }

        it { is_expected.to be_able_to(:create, spot) }
        it { is_expected.to be_able_to(:read, spot) }
        it { is_expected.to be_able_to(:update, spot) }
        it { is_expected.to be_able_to(:destroy, spot) }
      end
    end

    context "for an admin" do
      subject(:ability) { Ability.new(admin) }

      it { is_expected.to be_able_to(:create, spot) }
      it { is_expected.to be_able_to(:read, spot) }
      it { is_expected.to be_able_to(:update, spot) }
      it { is_expected.to be_able_to(:destroy, spot) }
    end
  end
end
