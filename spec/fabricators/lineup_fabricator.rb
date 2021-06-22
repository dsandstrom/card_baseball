# frozen_string_literal: true

Fabricator(:lineup) do
  with_dh false
  team
  name { sequence(:lineups) { |n| "Lineup Name #{n + 1}" } }
end

Fabricator(:dh_lineup, from: :lineup) do
  with_dh true
end
