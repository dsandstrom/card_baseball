# frozen_string_literal: true

# TODO: fabricator - make position/batting_order unique

Fabricator(:spot) do
  lineup
  position { rand(2..8) }
  batting_order { rand(1..8) }

  hitter do |attrs|
    hitter =
      if attrs[:position]
        key = Player.defense_key_for_position(attrs[:position])
        if key
          Fabricate(:hitter, key => rand(0..10))
        else
          Fabricate(:hitter)
        end
      else
        Fabricate(:hitter)
      end
    Fabricate(:contract, player: hitter, team: attrs[:lineup].team)
    Fabricate(:roster, player: hitter, team: attrs[:lineup].team, level: 4,
                       position: hitter.primary_position)
    hitter
  end
end
