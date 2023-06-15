# frozen_string_literal: true

require 'roda'
require_relative './app'

module StringofFate
  # Web controller for String of Fate API
  class App < Roda
    route('tags') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?
      @cards_route = '/cards'

      # GET /cards/tags/[tag_content]
      routing.get(String) do |tag_content|
        puts "TAG CONTENT: #{tag_content}"
        card_list = GetCardsByTag.new(App.config).call(
          @current_account, tag_content
        )
        puts 'BACK!'
        cards = Cards.new(card_list)

        view :cards_all, locals: {
          current_account: @current_account, cards:
        }

      rescue StandardError => e
        puts "ERROR GETTING CARDS BY TAG: #{e.inspect}"
        flash[:error] = 'Could not search card from tags'
      ensure
        routing.redirect @cards_route
      end
    end
  end
end
