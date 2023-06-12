# frozen_string_literal: true

class GetAccountDetails
  # Error for account cannot be created
  class InvalidAccount < StandardError
    def message
      'You are not authorized to see details of that account'
    end
  end

  def initialize(config)
    @config = config
  end

  def call(current_account, username)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/accounts/#{username}")
    raise InvalidAccount if response.code != 200

    data = JSON.parse(response.parse)['data']
    account_details = data['attributes']['account']
    auth_token = data['attributes']['auth_token']
    StringofFate::Account.new(account_details, auth_token)
  end
end
