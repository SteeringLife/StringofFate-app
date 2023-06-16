# frozen_string_literal: true

require 'roda'
require_relative './app'

module StringofFate
  # Web controller for String of Fate API
  class App < Roda
    route('public_hashtags') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # POST /public_hashtags/
      routing.post('public_hashtags') do
        public_hashtag_data = Form::NewPublicHashtag.new.call(routing.params)

        if public_hashtag_data.failure?
          flash[:error] = Form.message_values(public_hashtag_data)
          routing.halt
        end

        CreateNewPublicHashtag.new(App.config).call(
          current_account: @current_account,
          card_id:,
          public_hashtag_data: public_hashtag_data.to_h
        )

        flash[:notice] = 'Your tag was added'
      rescue StandardError => e
        puts "ERROR CREATING PUBLIC HASHTAG: #{e.inspect}"
        flash[:error] = 'Could not add tag'
      ensure
        routing.redirect @card_route
      end
    end
  end
end
