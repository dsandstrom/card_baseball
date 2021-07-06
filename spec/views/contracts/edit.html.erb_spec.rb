# frozen_string_literal: true

require "rails_helper"

RSpec.describe "contracts/edit", type: :view do
  let(:player) { Fabricate(:player) }
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league: league) }

  before do
    @player = assign(:player, player)
    @leagues = [league]
  end

  context "when player doesn't have a contract" do
    let(:contract) { Fabricate.build(:contract, player: player) }

    before(:each) do
      @contract = assign(:contract, contract)
    end

    it "renders the edit contract form" do
      render

      assert_select "form[action=?][method=?]",
                    player_contract_path(player), "post" do
        assert_select "select[name=?]", "contract[team_id]"
        assert_select "select[name=?]", "contract[length]"
      end
    end
  end

  context "when player has a contract" do
    let(:contract) { Fabricate(:contract, player: player) }

    before(:each) do
      @contract = assign(:contract, contract)
    end

    it "renders the edit contract form" do
      render

      assert_select "form[action=?][method=?]",
                    player_contract_path(player), "post" do
        assert_select "select[name=?]", "contract[team_id]"
        assert_select "select[name=?]", "contract[length]"
      end
    end
  end
end
