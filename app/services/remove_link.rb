# frozen_string_literal: true

module StringofFate
  # Service to add follower to card
  class RemoveLink
    class LinkNotRemoved < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, card_id:, link_data:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/cards/#{card_id}/links",
                             json: { link_id: link_data[:id] })

      raise LinkNotRemoved unless response.code == 200
    end
  end
end
