# frozen_string_literal: true

Fabricator(:roster) do
  team
  player { Fabricate(:pitcher) }
  level 1
  position 1
end
