# frozen_string_literal: true

require 'http'

module StringofFate
  # Returns all cards belonging to an account
  class DiscardCard
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, card_id:)
      config_url = "#{api_url}/cards/#{card_id}/receiver"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete(config_url)

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
