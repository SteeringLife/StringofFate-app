# frozen_string_literal: true

require 'http'

module StringofFate
  # Returns all cards belonging to an account
  class GetCard
    def initialize(config)
      @config = config
    end

    def call(current_account, card_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/cards/#{card_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
