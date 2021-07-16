# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/index", type: :view do
  let(:user) { Fabricate(:user) }

  before(:each) do
    assign(:users, [user])
  end

  it "renders new user link" do
    render

    expect(rendered).to have_link(nil, href: new_user_path)
  end

  it "renders a list of users" do
    render

    assert_select "#user_#{user.id}"
    expect(rendered).to have_link(nil, href: user_path(user))
    expect(rendered).to have_link(nil, href: edit_user_path(user))
    assert_select "a[data-method='delete'][href=?]", user_path(user)
  end
end
