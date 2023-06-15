# frozen_string_literal: true

require 'http'

module StringofFate
  # Create a new configuration link for a card
  class CreateNewCard
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, card_data:)
      config_url = "#{api_url}/cards"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: card_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
