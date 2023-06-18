# frozen_string_literal: true

require 'roda'
require_relative './app'

module StringofFate
  # Web controller for String of Fate API
  class App < Roda
    route('cards') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @cards_route = '/cards'

        routing.on(String) do |card_id|
          @card_route = "#{@cards_route}/#{card_id}"

          # `# POST /cards/[card_id]
          # routing.post do
          #   action = routing.params['action']
          #   new_card_name = routing.params['new_card_name']
          #   card_data = Form::NewCard.new.call(routing.params)
          #   if card_data.failure?
          #     flash[:error] = Form.validation_errors(card_data)
          #     routing.halt
          #   end

          #   task_list = {
          #     'edit' => { service: EditCard,
          #                 message: 'Edit the name of card',
          #                 err_msg: "Edit card error,  empty /already exists" },
          #     'delete' => { service: DeleteCard,
          #                   message: 'Deleted card',
          #                   err_msg: "Can't delete now! Please try it later🙏" }
          #   }

          #   task = task_list[action]

          #   task[:service].new(App.config).call(
          #     current_account: @current_account,
          #     new_card_name:,
          #     card_id:
          #   )
          #   flash[:notice] = task[:message]

          # rescue StandardError
          #   flash[:error] = task[:err_msg]

          # end

          # GET /cards/[card_id]
          routing.get do
            card_info = GetCard.new(App.config).call(
              @current_account, card_id
            )

            card = Card.new(card_info)

            view :card, locals: {
              current_account: @current_account, card:
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Card not found'
            routing.redirect @cards_route
          end

          # POST /cards/[card_id]/receivers
          routing.post('receivers') do
            action = routing.params['action']
            receiver_info = Form::ReceiverEmail.new.call(routing.params)

            if receiver_info.failure?
              flash[:error] = Form.validation_errors(receiver_info)
              routing.halt
            end

            task_list = {
              'add' => { service: GiveCard,
                         message: 'Give this card to reciever' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              receiver: receiver_info,
              card_id:
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find reciever'
          ensure
            routing.redirect @card_route
          end

          # POST /cards/[card_id]/links/
          routing.post('links') do
            link_data = Form::NewLink.new.call(routing.params)

            if link_data.failure?
              flash[:error] = Form.message_values(link_data)
              routing.halt
            end

            CreateNewLink.new(App.config).call(
              current_account: @current_account,
              card_id:,
              link_data: link_data.to_h
            )

            flash[:notice] = 'Your link was added'
          rescue StandardError => e
            puts "ERROR CREATING LINK: #{e.inspect}"
            flash[:error] = 'Could not add link'
          ensure
            routing.redirect @card_route
          end

          # # POST /cards/[card_id]/links/
          # routing.post('links') do
          #   link_data = Form::NewLink.new.call(routing.params)

          #   if link_data.failure?
          #     flash[:error] = Form.message_values(link_data)
          #     routing.halt
          #   end

          #   task_list = {
          #     'add' => { service: CreateNewLink,
          #                message: 'Your link was added' },
          #     'remove' => { service: RemoveLink,
          #                   message: 'Link Removed from this card' }
          #   }

          #   task = task_list[action]

          #   task[:service].new(App.config).call(
          #     current_account: @current_account,
          #     card_id:,
          #     link_data: link_data.to_h
          #   )

          #   flash[:notice] == task[:message]
          # rescue StandardError => e
          #   puts "ERROR IN #{action} LINK: #{e.inspect}"
          #   flash[:error] = "Could not #{action} link"
          # ensure
          #   routing.redirect @card_route
          # end

          # POST /cards/[card_id]/public_hashtags/
          routing.post('public_hashtags') do
            public_hashtag_data = Form::NewPublicHashtag.new.call(routing.params)

            if public_hashtag_data.failure?
              flash[:error] = Form.message_values(public_hashtag_data)
              routing.halt
            end

            CreateNewPublicHashtag.new(App.config).call(
              current_account: @current_account,
              public_hashtag_data: public_hashtag_data.to_h
            )
            AddPublicHashtagToCard.new(App.config).call(
              current_account: @current_account,
              public_hashtag_data: public_hashtag_data.to_h,
              card_id:
            )
          rescue CreateNewPublicHashtag::AlreadyExistsError
            AddPublicHashtagToCard.new(App.config).call(
              current_account: @current_account,
              public_hashtag_data: public_hashtag_data.to_h,
              card_id:
            )
            flash[:notice] = 'Your tag was added'
          rescue StandardError => e
            puts "ERROR CREATING PUBLIC HASHTAG: #{e.inspect}"
            flash[:error] = 'Could not add tag'
          ensure
            routing.redirect @card_route
          end

          # POST /cards/[card_id]/private_hashtags/
          routing.post('private_hashtags') do
            private_hashtags_data = Form::NewPrivateHashtag.new.call(routing.params)

            if private_hashtags_data.failure?
              flash[:error] = Form.message_values(private_hashtags_data)
              routing.halt
            end

            CreateNewPrivateHashtag.new(App.config).call(
              current_account: @current_account,
              card_id:,
              private_hashtags_data: private_hashtags_data.to_h
            )

          rescue StandardError => e
            puts "ERROR CREATING PUBLIC HASHTAG: #{e.inspect}"
            flash[:error] = 'Could not add tag'
          ensure
            routing.redirect @card_route
          end
        end

        # GET /cards/
        routing.get do
          card_list = GetAllCards.new(App.config).call(@current_account)

          cards = Cards.new(card_list)

          view :cards_all, locals: {
            current_account: @current_account, cards:
          }
        end

        # POST /cards/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?

          card_data = Form::NewCard.new.call(routing.params)
          if card_data.failure?
            flash[:error] = Form.message_values(card_data)
            routing.halt
          end

          CreateNewCard.new(App.config).call(
            current_account: @current_account,
            card_data: card_data.to_h
          )

          flash[:notice] = 'Add links and recievers to your new card'
        rescue StandardError => e
          puts "FAILURE Creating Card: #{e.inspect}"
          flash[:error] = 'Could not create card'
        ensure
          routing.redirect @cards_route
        end
      end
    end
  end
end
