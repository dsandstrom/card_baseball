# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  let(:contract) { Fabricate(:contract) }
  let(:user) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }

  describe "Contract model" do
    context "for a user" do
      subject(:ability) { Ability.new(user) }

      it { is_expected.not_to be_able_to(:create, contract) }
      it { is_expected.to be_able_to(:read, contract) }
      it { is_expected.not_to be_able_to(:update, contract) }
      it { is_expected.not_to be_able_to(:destroy, contract) }
    end

    context "for an admin" do
      subject(:ability) { Ability.new(admin) }

      it { is_expected.to be_able_to(:create, contract) }
      it { is_expected.to be_able_to(:read, contract) }
      it { is_expected.to be_able_to(:update, contract) }
      it { is_expected.to be_able_to(:destroy, contract) }
    end
  end
end
