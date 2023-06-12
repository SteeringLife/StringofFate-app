# frozen_string_literal: true

require 'roda'

module StringofFate
  # Web controller for String of Fate API
  class App < Roda
    route('cards') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @cards_route = '/cards'

        routing.on(String) do |card_id|
          @card_route = "#{@cards_route}/#{card_id}"

          # GET /cards/[card_id]
          routing.get do
            card_info = GetCard.new(App.config).call(
              @current_account, card_id
            )
            card = Card.new(card_info)

            view :card, locals: {
              current_account: @current_account, card: card
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Card not found'
            routing.redirect @cards_route
          end

          # POST /cards/[card_id]/recievers
          routing.post('recievers') do
            action = routing.params['action']
            reciever_info = Form::RecieverEmail.new.call(routing.params)
            if reciever_info.failure?
              flash[:error] = Form.validation_errors(reciever_info)
              routing.halt
            end

            task_list = {
              'add' => { service: GiveCard,
                         message: 'Give this card to reciever' },
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              reciever: reciever_info,
              card_id: card_id
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
              card_id: card_id,
              link_data: link_data.to_h
            )

            flash[:notice] = 'Your link was added'
          rescue StandardError => e
            puts "ERROR CREATING DOCUMENT: #{e.inspect}"
            flash[:error] = 'Could not add link'
          ensure
            routing.redirect @card_route
          end
        end

        # GET /cards/
        routing.get do
          card_list = GetAllCards.new(App.config).call(@current_account)

          cards = Cards.new(card_list)

          view :cards_all, locals: {
            current_account: @current_account, cards: cards
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
