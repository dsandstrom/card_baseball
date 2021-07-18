# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/index", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:another_user) { Fabricate(:user) }

  before(:each) do
    assign(:users, [user, another_user])
  end

  context "for an admin" do
    before { enable_can(view, admin) }

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
      expect(rendered).to have_link(nil, href: user_path(another_user))
      expect(rendered).to have_link(nil, href: edit_user_path(another_user))
      assert_select "a[data-method='delete'][href=?]", user_path(another_user)
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    it "doesn't render new user link" do
      render

      expect(rendered).not_to have_link(nil, href: new_user_path)
    end

    it "renders a list of users" do
      render

      assert_select "#user_#{user.id}"
      expect(rendered).to have_link(nil, href: user_path(user))
      assert_select "#user_#{another_user.id}"
      expect(rendered).to have_link(nil, href: user_path(another_user))
    end

    it "renders edit link only for current user" do
      render

      expect(rendered).to have_link(nil, href: edit_user_path(user))
      expect(rendered).not_to have_link(nil, href: edit_user_path(another_user))
    end

    it "doesn't render destroy user links" do
      render

      assert_select "a[data-method='delete'][href=?]", user_path(user),
                    count: 0
      assert_select "a[data-method='delete'][href=?]", user_path(another_user),
                    count: 0
    end
  end
end
