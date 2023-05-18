# frozen_string_literal: true

require 'http'

# Returns all links belonging to an account
class GetAllLinks
  def initialize(config)
    @config = config
  end

  def call(current_account)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/links")

    response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
  end
end
