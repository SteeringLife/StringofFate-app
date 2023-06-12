# frozen_string_literal: true

require 'http'

module StringofFate
  # Returns all cards belonging to an account
  class GetAllCards
    def initialize(config)
      @config = config
    end

    def call(current_account)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                    .get("#{@config.API_URL}/cards")

      response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
    end
  end
end
