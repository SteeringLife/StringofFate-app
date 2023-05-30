# frozen_string_literal: true

require_relative 'form_base'

module StringofFate
  module Form
    class NewLink < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_link.yml')

      params do
        required(:name).filled
        optional(:url).maybe(format?: URI::DEFAULT_PARSER.make_regexp)
      end
    end
  end
end
