# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:team) { Fabricate(:team) }
  let(:roster) { Fabricate(:roster, team:) }
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "Roster model" do
    context "for a user" do
      context "when not their team" do
        subject(:ability) { Ability.new(user) }

        it { is_expected.not_to be_able_to(:create, roster) }
        it { is_expected.to be_able_to(:read, roster) }
        it { is_expected.not_to be_able_to(:update, roster) }
        it { is_expected.not_to be_able_to(:destroy, roster) }
      end

      context "when their team" do
        let(:team) { Fabricate(:team, user:) }
        let(:roster) { Fabricate(:roster, team:) }

        subject(:ability) { Ability.new(user) }

        it { is_expected.to be_able_to(:create, roster) }
        it { is_expected.to be_able_to(:read, roster) }
        it { is_expected.to be_able_to(:update, roster) }
        it { is_expected.to be_able_to(:destroy, roster) }
      end
    end

    context "for an admin" do
      subject(:ability) { Ability.new(admin) }

      it { is_expected.to be_able_to(:create, roster) }
      it { is_expected.to be_able_to(:read, roster) }
      it { is_expected.to be_able_to(:update, roster) }
      it { is_expected.to be_able_to(:destroy, roster) }
    end
  end
end
