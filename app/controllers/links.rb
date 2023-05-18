# frozen_string_literal: true

require 'roda'

module StringofFate
  # Web controller for StringofFate API
  class App < Roda
    route('links') do |routing|
      routing.on do
        # GET /links/
        routing.get do
          if @current_account.logged_in?
            link_list = GetAllLinks.new(App.config).call(@current_account)

            links = Links.new(link_list)

            view :links_all,
                 locals: { current_user: @current_account, links: }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
