# frozen_string_literal: true

Fabricator(:contract) do
  player
  length { rand(Contract::LENGTH_OPTIONS) }
end
