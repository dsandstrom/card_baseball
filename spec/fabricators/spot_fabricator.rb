# frozen_string_literal: true

# TODO: fabricator - make position/batting_order unique

Fabricator(:spot) do
  lineup
  hitter
  position { rand(2..8) }
  batting_order { rand(1..8) }
end
