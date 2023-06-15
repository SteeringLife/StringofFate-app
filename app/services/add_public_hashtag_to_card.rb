# frozen_string_literal: true

module StringofFate
  # Service to add public_hashtag to card
  class AddPublicHashtagToCard
    class AddPublicHashtagError < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, public_hashtag_data:, card_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/cards/#{card_id}/public_hashtags",
                          json: { content: public_hashtag_data[:content] })

      raise AddPublicHashtagError unless response.code == 200
    end
  end
end
