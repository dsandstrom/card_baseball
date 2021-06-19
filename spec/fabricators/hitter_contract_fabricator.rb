# frozen_string_literal: true

Fabricator(:hitter_contract) do
  hitter
  length { rand(HitterContract::LENGTH_OPTIONS) }
end
