# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "User Name", email: "test@example.com",
                     password: "password", password_confirmation: "password")
  end

  subject { @user }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:time_zone) }
  it do
    is_expected.to validate_inclusion_of(:time_zone).in_array(
      ActiveSupport::TimeZone.all.map(&:name)
    )
  end

  it { is_expected.to have_many(:teams) }

  describe ".admins" do
    let!(:user) { Fabricate(:user) }
    let!(:admin) { Fabricate(:admin) }

    it "returns users with admin_role" do
      expect(User.admins).to eq([admin])
    end
  end

  describe "#admin?" do
    context "when admin_role is false" do
      before { subject.admin_role = false }

      it "returns false" do
        expect(subject.admin?).to eq(false)
      end
    end

    context "when admin_role is true" do
      before { subject.admin_role = true }

      it "returns true" do
        expect(subject.admin?).to eq(true)
      end
    end
  end

  describe "#simple_time_zone" do
    context "when time_zone is nil" do
      before { subject.time_zone = nil }

      it "returns nil" do
        expect(subject.simple_time_zone).to be_nil
      end
    end

    context "when time_zone is 'UTC'" do
      before { subject.time_zone = "UTC" }

      it "returns nil" do
        expect(subject.simple_time_zone).to eq("UTC")
      end
    end

    context "when time_zone is 'Pacific Time (US & Canada)'" do
      before { subject.time_zone = "Pacific Time (US & Canada)" }

      it "returns nil" do
        expect(subject.simple_time_zone).to eq("Pacific Time")
      end
    end
  end
end
