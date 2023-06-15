# frozen_string_literal: true

require 'http'

module StringofFate
  # Create a new configuration file for a card
  class CreateNewPrivateHashtag
    class AlreadyExistsError < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, card_id:, private_hashtags_data:)
      config_url = "#{api_url}/cards/#{card_id}/private_hashtags"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: private_hashtags_data)
      raise AlreadyExistsError if response.code == 409

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
