# frozen_string_literal: true

require "rails_helper"

RSpec.describe "hitter_contracts/edit", type: :view do
  let(:hitter) { Fabricate(:hitter) }
  let(:team) { Fabricate(:team) }

  before do
    @hitter = assign(:hitter, hitter)
  end

  context "when hitter doesn't have a contract" do
    let(:hitter_contract) { Fabricate.build(:hitter_contract, hitter: hitter) }

    before(:each) do
      @hitter_contract = assign(:hitter_contract, hitter_contract)
    end

    it "renders the edit hitter_contract form" do
      render

      assert_select "form[action=?][method=?]",
                    hitter_contract_path(hitter), "post" do
        assert_select "select[name=?]", "hitter_contract[team_id]"
        assert_select "select[name=?]", "hitter_contract[length]"
      end
    end
  end

  context "when hitter has a contract" do
    let(:hitter_contract) { Fabricate(:hitter_contract, hitter: hitter) }

    before(:each) do
      @hitter_contract = assign(:hitter_contract, hitter_contract)
    end

    it "renders the edit hitter_contract form" do
      render

      assert_select "form[action=?][method=?]",
                    hitter_contract_path(hitter), "post" do
        assert_select "select[name=?]", "hitter_contract[team_id]"
        assert_select "select[name=?]", "hitter_contract[length]"
      end
    end
  end
end
