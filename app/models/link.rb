# frozen_string_literal: true

module StringofFate
  # Behaviors of the currently logged in account
  class Link
    attr_reader :id, :name, :url, :platform

    def initialize(proj_info)
      @id = proj_info['attributes']['id']
      @name = proj_info['attributes']['nickname']
      @repo_url = proj_info['attributes']['url']
      @platform = proj_info['attributes']['platform']
    end
  end
end
