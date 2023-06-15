# frozen_string_literal: true

require_relative 'card'

module StringofFate
  # Behaviors of the currently logged in account
  class PrivateHashtags
    attr_reader :all

    def initialize(private_hashtags_list)
      @all = private_hashtags_list.map do |private_hashtag|
        PrivateHashtag.new(private_hashtag)
      end
    end
  end
end
