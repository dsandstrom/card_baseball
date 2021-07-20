# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/new", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate.build(:user) }

  before(:each) { assign(:user, user) }

  context "for an admin" do
    before { enable_can(view, admin) }

    it "renders new user form" do
      render

      assert_select "form[action=?][method=?]", users_path, "post" do
        assert_select "input[name=?]", "user[name]"
        assert_select "input[name=?]", "user[email]"
        assert_select "input[name=?]", "user[admin_role]"
        assert_select "input[name=?]", "user[city]"
        assert_select "select[name=?]", "user[time_zone]"
      end
    end
  end
end
