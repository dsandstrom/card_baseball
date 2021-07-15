# frozen_string_literal: true

Fabricator(:user) do
  name { sequence(:users) { |n| "User Name #{n + 1}" } }
  email { sequence(:users) { |n| "user-email-#{n + 1}@example.com" } }
  password { '12345679' }
  password_confirmation { '12345679' }
end
