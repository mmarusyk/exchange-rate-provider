require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Exchange Rate Provider API',
        version: 'v1',
        description: 'API for retrieving exchange rates.'
      },
      servers: [
        {
          url: '{defaultHost}',
          variables: {
            defaultHost: {
              default: 'http://localhost:3000'
            }
          }
        }
      ]
    }
  }

  config.after do |example|
    if respond_to?(:response) && response&.body.present?
      description = example.full_description.split.from(3).join(' ')

      example.metadata[:response][:content] = {
        'application/json' => {
          examples: {
            description => {
              value: JSON.parse(response.body, symbolize_names: true)
            }
          }
        }
      }
    end
  rescue JSON::ParserError
    nil
  end
end
