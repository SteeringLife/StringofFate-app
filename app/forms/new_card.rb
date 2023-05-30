# frozen_string_literal: true

require_relative 'form_base'

module StringofFate
  module Form
    class NewCard < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_card.yml')

      params do
        required(:name).filled
        required(:description).maybe(:string)
      end
    end
  end
end
