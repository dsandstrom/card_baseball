# frozen_string_literal: true

Fabricator(:lineup) do
  team
  name { sequence(:lineups) { |n| "Lineup Name #{n + 1}" } }
end
