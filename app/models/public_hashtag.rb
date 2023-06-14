# frozen_string_literal: true

module StringofFate
  # Behaviors of the currently logged in account
  class PublicHashtag
    attr_reader :id, :content # basic info

    def initialize(public_hashtag_info_info)
      process_attributes(public_hashtag_info_info['attributes'])
      process_policies(public_hashtag_info_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @content = attributes['content']
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end
  end
end
