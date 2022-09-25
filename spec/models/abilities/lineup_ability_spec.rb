# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team:) }
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "Lineup model" do
    context "for a user" do
      context "when not their team" do
        subject(:ability) { Ability.new(user) }

        it { is_expected.not_to be_able_to(:create, lineup) }
        it { is_expected.to be_able_to(:read, lineup) }
        it { is_expected.not_to be_able_to(:update, lineup) }
        it { is_expected.not_to be_able_to(:destroy, lineup) }
      end

      context "when their team" do
        let(:team) { Fabricate(:team, user:) }
        let(:lineup) { Fabricate(:lineup, team:) }

        subject(:ability) { Ability.new(user) }

        it { is_expected.to be_able_to(:create, lineup) }
        it { is_expected.to be_able_to(:read, lineup) }
        it { is_expected.to be_able_to(:update, lineup) }
        it { is_expected.to be_able_to(:destroy, lineup) }
      end
    end

    context "for an admin" do
      subject(:ability) { Ability.new(admin) }

      it { is_expected.to be_able_to(:create, lineup) }
      it { is_expected.to be_able_to(:read, lineup) }
      it { is_expected.to be_able_to(:update, lineup) }
      it { is_expected.to be_able_to(:destroy, lineup) }
    end
  end
end
