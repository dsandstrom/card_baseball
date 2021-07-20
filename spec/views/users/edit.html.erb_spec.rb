# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/edit", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  context "for an admin" do
    before do
      enable_can(view, admin)
      assign(:user, user)
    end

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

  context "for current admin" do
    before do
      enable_can(view, admin)
      assign(:user, admin)
    end

    it "renders the edit user form" do
      render

      assert_select "form[action=?][method=?]", user_path(admin), "post" do
        assert_select "input[name=?]", "user[name]"
        assert_select "input[name=?]", "user[email]"
        assert_select "input[name=?]", "user[admin_role]", count: 0
        assert_select "input[name=?]", "user[city]"
        assert_select "select[name=?]", "user[time_zone]"
      end
    end
  end

  context "for current user" do
    before do
      enable_can(view, user)
      assign(:user, user)
    end

    it "renders the edit user form" do
      render

      assert_select "form[action=?][method=?]", user_path(user), "post" do
        assert_select "input[name=?]", "user[name]"
        assert_select "input[name=?]", "user[email]"
        assert_select "input[name=?]", "user[admin_role]", count: 0
        assert_select "input[name=?]", "user[city]"
        assert_select "select[name=?]", "user[time_zone]"
      end
    end
  end
end
