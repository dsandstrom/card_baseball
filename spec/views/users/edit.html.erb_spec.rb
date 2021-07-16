# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/edit", type: :view do
  let(:user) { Fabricate(:user) }

  before(:each) { @user = assign(:user, user) }

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(user), "post" do
      assert_select "input[name=?]", "user[name]"
      assert_select "input[name=?]", "user[email]"
      assert_select "input[name=?]", "user[admin_role]"
      assert_select "input[name=?]", "user[city]"
      assert_select "select[name=?]", "user[time_zone]"
    end
  end
end
