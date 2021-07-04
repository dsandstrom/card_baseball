# frozen_string_literal: true

require "rails_helper"

RSpec.describe League, type: :model do
  before do
    @league = League.new(name: "National League")
  end

  subject { @league }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it { is_expected.to have_many(:teams) }
end
