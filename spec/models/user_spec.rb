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
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

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
end
