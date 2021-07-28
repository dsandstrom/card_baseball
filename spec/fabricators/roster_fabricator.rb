# frozen_string_literal: true

Fabricator(:roster) do
  team
  level 1
  position 1
  player { Fabricate(:pitcher) }

  after_build do |roster|
    next if roster.player.contract

    Fabricate(:contract, team: roster.team, player: roster.player)
  end
end
