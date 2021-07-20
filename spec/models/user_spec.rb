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

  describe "#location" do
    before do
      subject.city = ""
      subject.time_zone = nil
    end

    context "when city and time_zone are nil" do
      it "returns nil" do
        expect(subject.location).to be_nil
      end
    end

    context "when time_zone only" do
      before do
        subject.time_zone = "Pacific Time (US & Canada)"
      end

      it "returns simple_time_zone" do
        expect(subject.location).to eq("Pacific Time")
      end
    end

    context "when city only" do
      before { subject.city = "Austin" }

      it "returns simple_time_zone" do
        expect(subject.location).to eq("Austin")
      end
    end

    context "when city and time_zone" do
      before do
        subject.city = "Austin"
        subject.time_zone = "Pacific Time (US & Canada)"
      end

      it "returns simple_time_zone" do
        expect(subject.location).to eq("Austin (Pacific Time)")
      end
    end
  end

  describe "#password?" do
    context "when user has an encrypted_password" do
      let(:user) { Fabricate(:user) }

      it "returns true" do
        expect(user.password?).to eq(true)
      end
    end

    context "when user doesn't have an encrypted_password" do
      let(:user) do
        Fabricate(:user, password: nil, password_confirmation: nil,
                         confirmed_at: nil)
      end

      it "returns false" do
        expect(user.password?).to eq(false)
      end
    end
  end

  # https://github.com/heartcombo/devise/wiki/How-To:-Email-only-sign-up
  # catch any changes in Devise's behavior in the future
  describe "#set_reset_password_token" do
    it "returns the plaintext token" do
      potential_token = subject.send(:set_reset_password_token)
      potential_token_digest =
        Devise.token_generator.digest(subject, :reset_password_token,
                                      potential_token)
      actual_token_digest = subject.reset_password_token
      expect(potential_token_digest).to eql(actual_token_digest)
    end
  end
end
