# frozen_string_literal: true

require_relative 'link'

module StringofFate
  # Behaviors of the currently logged in account
  class Links
    attr_reader :all

    def initialize(links_list)
      @all = links_list.map do |link|
        Link.new(link)
      end
    end
  end
end
