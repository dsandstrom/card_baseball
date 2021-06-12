# frozen_string_literal: true

Fabricator(:league) do
  name { sequence(:leagues) { |n| "League Name #{n + 1}" } }
end
