# frozen_string_literal: true

require_relative 'card'

module StringofFate
  # Behaviors of the currently logged in account
  class PublicHashtags
    attr_reader :all

    def initialize(public_hashtags_list)
      @all = public_hashtags_list.map do |public_hashtag|
        PublicHashtag.new(public_hashtag)
      end
    end
  end
end
