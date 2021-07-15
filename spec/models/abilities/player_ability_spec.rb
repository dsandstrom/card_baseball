# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:player) { Fabricate(:player) }
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "Player model" do
    context "for a user" do
      subject(:ability) { Ability.new(user) }

      it { is_expected.not_to be_able_to(:create, player) }
      it { is_expected.to be_able_to(:read, player) }
      it { is_expected.not_to be_able_to(:update, player) }
      it { is_expected.not_to be_able_to(:destroy, player) }
    end

    context "for an admin" do
      subject(:ability) { Ability.new(admin) }

      it { is_expected.to be_able_to(:create, player) }
      it { is_expected.to be_able_to(:read, player) }
      it { is_expected.to be_able_to(:update, player) }
      it { is_expected.to be_able_to(:destroy, player) }
    end
  end
end
