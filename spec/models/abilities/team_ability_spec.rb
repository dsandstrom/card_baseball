# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:team) { Fabricate(:team) }
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "Team model" do
    context "for a user" do
      context "when not their team" do
        subject(:ability) { Ability.new(user) }

        it { is_expected.not_to be_able_to(:create, team) }
        it { is_expected.to be_able_to(:read, team) }
        it { is_expected.not_to be_able_to(:update, team) }
        it { is_expected.not_to be_able_to(:destroy, team) }
      end

      context "when their team" do
        let(:team) { Fabricate(:team, user: user) }

        subject(:ability) { Ability.new(user) }

        it { is_expected.not_to be_able_to(:create, team) }
        it { is_expected.to be_able_to(:read, team) }
        it { is_expected.to be_able_to(:update, team) }
        it { is_expected.not_to be_able_to(:destroy, team) }
      end
    end

    context "for an admin" do
      subject(:ability) { Ability.new(admin) }

      it { is_expected.to be_able_to(:create, team) }
      it { is_expected.to be_able_to(:read, team) }
      it { is_expected.to be_able_to(:update, team) }
      it { is_expected.to be_able_to(:destroy, team) }
    end
  end
end
