# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability do
  describe "User model" do
    let(:random_user) { Fabricate(:user) }
    let(:random_admin) { Fabricate(:admin) }

    describe "for an admin" do
      let(:admin) { Fabricate(:admin) }
      subject(:ability) { Ability.new(admin) }

      context "when user" do
        it { is_expected.to be_able_to(:create, random_user) }
        it { is_expected.to be_able_to(:read, random_user) }
        it { is_expected.to be_able_to(:update, random_user) }
        it { is_expected.to be_able_to(:destroy, random_user) }
      end

      context "when themselves" do
        it { is_expected.to be_able_to(:create, admin) }
        it { is_expected.to be_able_to(:read, admin) }
        it { is_expected.to be_able_to(:update, admin) }
        it { is_expected.not_to be_able_to(:destroy, admin) }
      end

      context "when another admin" do
        it { is_expected.to be_able_to(:create, random_admin) }
        it { is_expected.to be_able_to(:read, random_admin) }
        it { is_expected.to be_able_to(:update, random_admin) }
        it { is_expected.to be_able_to(:destroy, random_admin) }
      end
    end

    describe "for a user" do
      let(:user) { Fabricate(:user) }
      subject(:ability) { Ability.new(user) }

      context "when another user" do
        it { is_expected.not_to be_able_to(:create, random_user) }
        it { is_expected.to be_able_to(:read, random_user) }
        it { is_expected.not_to be_able_to(:update, random_user) }
        it { is_expected.not_to be_able_to(:destroy, random_user) }
      end

      context "when themselves" do
        it { is_expected.not_to be_able_to(:create, user) }
        it { is_expected.to be_able_to(:read, user) }
        it { is_expected.to be_able_to(:update, user) }
        it { is_expected.not_to be_able_to(:destroy, user) }
      end

      context "when an admin" do
        it { is_expected.not_to be_able_to(:create, random_admin) }
        it { is_expected.to be_able_to(:read, random_admin) }
        it { is_expected.not_to be_able_to(:update, random_admin) }
        it { is_expected.not_to be_able_to(:destroy, random_admin) }
      end
    end

    context "for a guest" do
      subject(:ability) { Ability.new(nil) }

      context "when new User" do
        let(:new_user) { Fabricate.build(:user) }

        it { is_expected.not_to be_able_to(:create, new_user) }
        it { is_expected.not_to be_able_to(:read, new_user) }
        it { is_expected.not_to be_able_to(:update, new_user) }
        it { is_expected.not_to be_able_to(:destroy, new_user) }
        it { is_expected.not_to be_able_to(:cancel, new_user) }
        it { is_expected.not_to be_able_to(:promote, new_user) }
      end
    end
  end
end
