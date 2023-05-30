# frozen_string_literal: true

require_relative 'card'

module StringofFate
  # Behaviors of the currently logged in account
  class Link
    attr_reader :id, :name, :url,
                :card # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['include'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['nickname']
      @url  = attributes['url']
    end

    def process_included(included)
      @card = Card.new(included['card'])
    end
  end
end
