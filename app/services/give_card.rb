# frozen_string_literal: true

module StringofFate
  # Service to add reciever to card
  class GiveCard
    class CardNotGave < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, reciever:, card_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/cards/#{card_id}/recievers",
                          json: { email: reciever[:email] })

      raise CardNotGave unless response.code == 200
    end
  end
end
