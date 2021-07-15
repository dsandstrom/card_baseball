# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:league) { Fabricate(:league) }
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "League model" do
    context "for a user" do
      subject(:ability) { Ability.new(user) }

      it { is_expected.not_to be_able_to(:create, league) }
      it { is_expected.to be_able_to(:read, league) }
      it { is_expected.not_to be_able_to(:update, league) }
      it { is_expected.not_to be_able_to(:destroy, league) }
    end

    context "for an admin" do
      subject(:ability) { Ability.new(admin) }

      it { is_expected.to be_able_to(:create, league) }
      it { is_expected.to be_able_to(:read, league) }
      it { is_expected.to be_able_to(:update, league) }
      it { is_expected.to be_able_to(:destroy, league) }
    end
  end
end
