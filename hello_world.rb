# frozen_string_literal: true
require 'bundler'
require 'time'

Bundler.require(:default) # Load core modules

# Our Rack application to be executed by rackup
class HelloWorld
  DEFAULT_HEADERS = {}.freeze

  def call(env)
    content_type, *body =
      case env['PATH_INFO']
      when '/plaintext'
        # Test type 6: Plaintext
        ['text/plain', 'Hello, World!']
      end

    return 200,
      DEFAULT_HEADERS.merge(
        'Content-Type'=>content_type,
        'Date'=>Time.now.httpdate
      ),
      body
  end
end
