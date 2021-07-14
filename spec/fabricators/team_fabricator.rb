# frozen_string_literal: true

Fabricator(:team) do
  name { sequence(:teams) { |n| "Team Name #{n + 1}" } }
  identifier { sequence(:teams) { |n| "ID#{n + 1}" } }
  league
end
