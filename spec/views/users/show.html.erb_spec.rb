# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/show", type: :view do
  let(:user) { Fabricate(:user) }
  let(:first_team) { Fabricate(:team) }
  let(:second_team) { Fabricate(:team) }

  before(:each) do
    @user = assign(:user, user)
    assign(:teams, [])
  end

  it "renders user" do
    render

    assert_select ".user-name", user.name
    assert_select ".user-email", user.email
    assert_select ".user-location", user.location
  end

  it "renders edit link" do
    render

    expect(rendered).to have_link(nil, href: edit_user_path(user))
  end

  context "with no teams" do
    before { first_team }

    it "renders" do
      render

      assert_select ".teams", count: 0
    end
  end

  context "with one team" do
    before do
      first_team.update(user_id: user.id)
      assign(:teams, [first_team])
    end

    it "renders it" do
      render

      assert_select ".teams #team_#{first_team.id}"
    end
  end

  context "with two teams" do
    before do
      first_team.update(user_id: user.id)
      second_team.update(user_id: user.id)
      assign(:teams, [first_team, second_team])
    end

    it "renders it" do
      render

      assert_select ".teams #team_#{first_team.id}"
      assert_select ".teams #team_#{second_team.id}"
    end
  end
end
