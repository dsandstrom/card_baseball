# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contract, type: :model do
  let(:player) { Fabricate(:player) }

  before do
    @player_contract = Contract.new(player_id: player.id, length: 1)
  end

  subject { @player_contract }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:player_id) }
  it { is_expected.to validate_inclusion_of(:length).in_range(1..3) }

  it { is_expected.to belong_to(:player) }
  it { is_expected.to belong_to(:team).optional }
end
