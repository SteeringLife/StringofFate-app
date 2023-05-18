# frozen_string_literal: true

module StringofFate
  # Behaviors of the currently logged in account
  class Link
    attr_reader :id, :name, :url, :platform

    def initialize(link_info)
      @id = link_info['attributes']['id']
      @name = link_info['attributes']['nickname']
      @repo_url = link_info['attributes']['url']
      @platform_id = link_info['platform']['id']
    end
  end
end
