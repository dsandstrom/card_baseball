# frozen_string_literal: true

Fabricator(:team) do
  name { sequence(:teams) { |n| "Team Name #{n + 1}" } }
  league
end
