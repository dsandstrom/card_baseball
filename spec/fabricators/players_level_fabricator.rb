# frozen_string_literal: true

Fabricator(:players_level) do
  player { Fabricate(:pitcher) }
  level 1
  position 1
end
