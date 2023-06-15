# frozen_string_literal: true

require 'http'

module StringofFate
  # Returns all cards belonging to an account
  class GetCardsByTag
    def initialize(config)
      @config = config
    end

    def call(current_account, tag_content)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/cards/tags/#{tag_content}")

      response.code == 200 ? JSON.parse(response.to_s)['data'] : raise
    end
  end
end
