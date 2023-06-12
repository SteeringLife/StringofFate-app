# frozen_string_literal: true

require 'roda'

module StringofFate
  # Web controller for String of Fate API
  class App < Roda
    route('cards') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @projects_route = '/cards'

        routing.on(String) do |card_id|
          @project_route = "#{@projects_route}/#{card_id}"

          # GET /cards/[card_id]
          routing.get do
            card_info = GetCard.new(App.config).call(
              @current_account, card_id
            )
            project = Project.new(card_info)

            view :project, locals: {
              current_account: @current_account, project: project
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Project not found'
            routing.redirect @projects_route
          end

          # POST /cards/[card_id]/collaborators
          routing.post('collaborators') do
            action = routing.params['action']
            collaborator_info = Form::CollaboratorEmail.new.call(routing.params)
            if collaborator_info.failure?
              flash[:error] = Form.validation_errors(collaborator_info)
              routing.halt
            end

            task_list = {
              'add' => { service: AddCollaborator,
                         message: 'Added new collaborator to project' },
              'remove' => { service: RemoveCollaborator,
                            message: 'Removed collaborator from project' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              collaborator: collaborator_info,
              project_id: card_id
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find collaborator'
          ensure
            routing.redirect @project_route
          end

          # POST /cards/[card_id]/documents/
          routing.post('documents') do
            document_data = Form::NewDocument.new.call(routing.params)
            if document_data.failure?
              flash[:error] = Form.message_values(document_data)
              routing.halt
            end

            CreateNewDocument.new(App.config).call(
              current_account: @current_account,
              project_id: card_id,
              document_data: document_data.to_h
            )

            flash[:notice] = 'Your document was added'
          rescue StandardError => e
            puts "ERROR CREATING DOCUMENT: #{e.inspect}"
            flash[:error] = 'Could not add document'
          ensure
            routing.redirect @project_route
          end
        end

        # GET /cards/
        routing.get do
          project_list = GetAllProjects.new(App.config).call(@current_account)

          cards = Projects.new(project_list)

          view :projects_all, locals: {
            current_account: @current_account, cards: cards
          }
        end

        # POST /cards/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?

          project_data = Form::NewProject.new.call(routing.params)
          if project_data.failure?
            flash[:error] = Form.message_values(project_data)
            routing.halt
          end

          CreateNewProject.new(App.config).call(
            current_account: @current_account,
            project_data: project_data.to_h
          )

          flash[:notice] = 'Add documents and collaborators to your new project'
        rescue StandardError => e
          puts "FAILURE Creating Project: #{e.inspect}"
          flash[:error] = 'Could not create project'
        ensure
          routing.redirect @projects_route
        end
      end
    end
  end
end
