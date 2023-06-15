# frozen_string_literal: true

module StringofFate
  # Behaviors of the currently logged in account
  class PrivateHashtag
    attr_reader :id, :content # basic info

    def initialize(private_hashtag_info)
      process_attributes(private_hashtag_info['attributes'])
      process_policies(private_hashtag_info['policies'])
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
