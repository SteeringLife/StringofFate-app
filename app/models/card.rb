# frozen_string_literal: true

module StringofFate
  # Behaviors of the currently logged in account
  class Card
    attr_reader :id, :name, :description, # basic info
                :owner, :receivers, :links, :policies # full details

    def initialize(card_info)
      process_attributes(card_info['attributes'])
      process_relationships(card_info['relationships'])
      process_policies(card_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @description = attributes['description']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @receivers = process_receivers(relationships['receivers'])
      @links = process_links(relationships['links'])
      @public_hashtags = process_public_hashtags(relationships['public_hashtags'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_links(links_info)
      return nil unless links_info

      links_info.map { |link_info| Link.new(link_info) }
    end

    def process_public_hashtags(public_hashtags_info)
      return nil unless public_hashtags_info

      public_hashtags_info.map { |public_hashtag_info| PublicHashtag.new(public_hashtag_info) }
    end

    def process_receivers(receivers)
      return nil unless receivers

      receivers.map { |account_info| Account.new(account_info) }
    end
  end
end
