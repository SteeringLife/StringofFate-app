# frozen_string_literal: true

require_relative 'card'

module StringofFate
  # Behaviors of the currently logged in account
  class Cards
    attr_reader :all

    def initialize(cards_list)
      @all = cards_list.map do |card|
        Card.new(card)
      end
    end
  end
end
