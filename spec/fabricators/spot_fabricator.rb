# frozen_string_literal: true

# TODO: fabricator - make position/batting_order unique

Fabricator(:spot) do
  lineup
  position { rand(2..8) }
  batting_order { rand(1..8) }

  player do |attrs|
    player =
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
    Fabricate(:roster, player: player, team: attrs[:lineup].team, level: 4,
                       position: player.primary_position)
    player
  end
end
