# frozen_string_literal: true

require 'http'

module StringofFate
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end
    class ApiServerError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(username:, password:)
      response = HTTP.post("#{@config.API_URL}/auth/authenticate",
                           json: { username:, password: })

      raise(UnauthorizedError) unless response.code == 200

      response.parse['attributes']
    end
  end
end
