# frozen_string_literal: true

Fabricator(:hitter_contract) do
  hitter
  length { HitterContract::LENGTH_OPTIONS.sample }
end
