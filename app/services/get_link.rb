# frozen_string_literal: true

require 'http'

module StringofFate
  # Returns all cards belonging to an account
  class GetLink
    def initialize(config)
      @config = config
    end

    def call(user, link_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                    .get("#{@config.API_URL}/links/#{link_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
