# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/show", type: :view do
  let(:user) { Fabricate(:user) }

  before(:each) do
    @user = assign(:user, user)
    assign(:teams, [])
  end

  it "renders user" do
    render

    assert_select ".user-name", user.name
    assert_select ".user-email", user.email
  end

  it "renders edit link" do
    render

    expect(rendered).to have_link(nil, href: edit_user_path(user))
  end
end
