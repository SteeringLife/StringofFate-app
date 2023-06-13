# frozen_string_literal: true

require 'http'

module StringofFate
  # Returns an authenticated user, or nil
  class CreateAccount
    # Error for accounts that cannot be created
    class InvalidAccount < StandardError
      def message = 'This account can no longer be created: please start again'
    end

    def initialize(config)
      @config = config
    end

    def call(email:, username:, password:, realname:, showname:)
      message = { email:,
                  username:,
                  password:,
                  realname:,
                  showname: }

      response = HTTP.post(
        "#{@config.API_URL}/accounts/",
        json: message
      )

      raise InvalidAccount unless response.code == 201
    end
  end
end
