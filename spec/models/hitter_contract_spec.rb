# frozen_string_literal: true

require "rails_helper"

RSpec.describe HitterContract, type: :model do
  let(:hitter) { Fabricate(:hitter) }

  before do
    @hitter_contract = HitterContract.new(hitter_id: hitter.id, length: 1)
  end

  subject { @hitter_contract }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:hitter_id) }
  it { is_expected.to validate_inclusion_of(:length).in_range(1..3) }

  it { is_expected.to belong_to(:hitter) }
  it { is_expected.to belong_to(:team).optional }
end
