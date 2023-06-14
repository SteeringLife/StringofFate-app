# frozen_string_literal: true

module StringofFate
  # Service to add receiver to card
  class GiveCard
    class CardNotGave < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, receiver:, card_id:)
      puts "GiveCard: #{current_account.inspect} #{receiver.inspect} #{card_id}"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/cards/#{card_id}/receivers",
                          json: { email: receiver[:email] })
      puts "GiveCard: #{response.inspect}"
      raise CardNotGave unless response.code == 200
    end
  end
end
