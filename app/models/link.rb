# frozen_string_literal: true

module StringofFate
  # Behaviors of the currently logged in account
  class Link
    attr_reader :id, :name, :url, :platform

    def initialize(link_info)
      @id = link_info['attributes']['id']
      @name = link_info['attributes']['nickname']
      @url = link_info['attributes']['url']
      @category = link_info['include']['platform']['attributes']['category']
      @platform = link_info['include']['platform']['attributes']['name']
    end
  end
end
